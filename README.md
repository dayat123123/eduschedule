# EduSchedule

EduSchedule is a Flutter web application for school schedule planning and optimization.

## Vercel Deployment

This project is configured for deployment on Vercel using Flutter web.

To build locally:

```bash
flutter pub get
flutter build web --release
```

Vercel will use the `vercel-build` script in `package.json` and publish the contents of `build/web`.
