// app/javascript/application.js
import { Application } from "@hotwired/stimulus"

import * as Sentry from "@sentry/browser";

Sentry.init({
  dsn: 'https://b3f2fb6ea1193573fc2f6d9f78e33828@o4507742850973696.ingest.us.sentry.io/4507770722254848',
  integrations: [
    Sentry.browserTracingIntegration(),
    Sentry.replayIntegration(),
  ],
  tracesSampleRate: 1.0,
  env: 'development'
});

const application = Application.start()

application.debug = false
window.Stimulus = application

export { application }
