import 'package:flutter/material.dart';
import 'screens/hero_screen.dart';
import 'screens/form_screen.dart';
import 'screens/generating_screen.dart';
import 'screens/result_screen.dart';
import 'models.dart';
import 'data.dart';
import 'ga.dart';
import 'theme.dart';

void main() {
  runApp(const JadwalPintarApp());
}

class JadwalPintarApp extends StatefulWidget {
  const JadwalPintarApp({super.key});

  @override
  State<JadwalPintarApp> createState() => _JadwalPintarAppState();
}

class _JadwalPintarAppState extends State<JadwalPintarApp> {
  String screen = 'hero'; // hero, form, generating, result
  int step = 0;
  School school = dummySchool;
  List<Subject> mapel = List.from(dummyMapel);
  List<Teacher> guru = List.from(dummyGuru);
  Constraints constraints = Constraints(
    guruTidakBentrok: true,
    kelasTidakBentrok: true,
    ruangTidakBentrok: true,
    hindariJamKosong: true,
    prioritasPreferensiGuru: true,
    maxBeratPerHari: 2,
    maxBerturutan: 3,
  );
  GAConfig gaConfig = GAConfig(
    populationSize: 50,
    mutationRate: 0.1,
    crossoverRate: 0.8,
    maxGeneration: 100,
    eliteSize: 5,
  );
  int progressGen = 0;
  int currentFitness = 0;
  List<Gene>? result;
  List<FitnessHistory> fitnessHistory = [];
  String? toastMessage;
  String toastType = 'success';

  void showToast(String msg, {String type = 'success'}) {
    setState(() {
      toastMessage = msg;
      toastType = type;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => toastMessage = null);
    });
  }

  void setScreen(String newScreen) {
    setState(() => screen = newScreen);
  }

  void setStep(int newStep) {
    setState(() => step = newStep);
  }

  void updateSchool(School newSchool) {
    setState(() => school = newSchool);
  }

  void updateMapel(List<Subject> newMapel) {
    setState(() => mapel = newMapel);
  }

  void updateGuru(List<Teacher> newGuru) {
    setState(() => guru = newGuru);
  }

  void updateConstraints(Constraints newConstraints) {
    setState(() => constraints = newConstraints);
  }

  void updateGAConfig(GAConfig newGAConfig) {
    setState(() => gaConfig = newGAConfig);
  }

  void updateProgress(int gen, int fitness, int total) {
    setState(() {
      progressGen = gen;
      currentFitness = fitness;
    });
  }

  void setResult(
    List<Gene>? schedule,
    List<FitnessHistory> history,
    int finalFitness,
  ) {
    setState(() {
      result = schedule;
      fitnessHistory = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    switch (screen) {
      case 'hero':
        currentScreen = HeroScreen(onStart: () => setScreen('form'));
        break;
      case 'form':
        currentScreen = FormScreen(
          step: step,
          school: school,
          mapel: mapel,
          guru: guru,
          constraints: constraints,
          gaConfig: gaConfig,
          onStepChange: setStep,
          onSchoolChange: updateSchool,
          onMapelChange: updateMapel,
          onGuruChange: updateGuru,
          onConstraintsChange: updateConstraints,
          onGAConfigChange: updateGAConfig,
          onGenerate: () async {
            if (mapel.isEmpty) {
              showToast("Tambahkan minimal 1 mata pelajaran!", type: 'error');
              return;
            }
            if (guru.isEmpty) {
              showToast("Tambahkan minimal 1 guru!", type: 'error');
              return;
            }
            setScreen('generating');
            try {
              final res = await runGeneticAlgorithm(
                mapel,
                guru,
                school,
                constraints,
                gaConfig,
                updateProgress,
              );
              setResult(
                res['schedule'] as List<Gene>?,
                res['fitnessHistory'] as List<FitnessHistory>,
                res['finalFitness'] as int,
              );
              setScreen('result');
              showToast(
                "🎉 Jadwal berhasil dibuat! Fitness: ${res['finalFitness']}",
              );
            } catch (e) {
              showToast("Terjadi error saat generate jadwal.", type: 'error');
              setScreen('form');
            }
          },
          onBackToHero: () => setScreen('hero'),
        );
        break;
      case 'generating':
        currentScreen = GeneratingScreen(
          progress: progressGen,
          fitness: currentFitness,
          total: gaConfig.maxGeneration,
        );
        break;
      case 'result':
        currentScreen = ResultScreen(
          schedule: result,
          school: school,
          fitnessHistory: fitnessHistory,
          onEdit: () => setScreen('form'),
          onTapBack: () => setScreen('hero'),
        );
        break;
      default:
        currentScreen = const SizedBox();
    }

    return MaterialApp(
      title: 'JadwalPintar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Stack(
          children: [
            currentScreen,
            if (toastMessage != null)
              Positioned(
                bottom: 24,
                right: 24,
                child: ToastNotif(message: toastMessage!, type: toastType),
              ),
          ],
        ),
      ),
    );
  }
}

class ToastNotif extends StatelessWidget {
  final String message;
  final String type;

  const ToastNotif({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    final isError = type == 'error';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isError
            ? AppColors.toastErrorBackground
            : AppColors.toastSuccessBackground,
        border: Border.all(
          color: isError
              ? AppColors.toastErrorBorder
              : AppColors.toastSuccessBorder,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isError
              ? AppColors.toastErrorText
              : AppColors.toastSuccessText,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
