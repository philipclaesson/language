// Service worker for Web Push (daily training reminder). It only handles push
// display + click — the app itself isn't cached/offline. The payload shape is set
// by server/push/send.ts (PushPayload): { title, body, url }.

self.addEventListener("push", (event) => {
  let data = {};
  try {
    data = event.data ? event.data.json() : {};
  } catch (_) {
    // Non-JSON payload — fall back to defaults below.
  }
  const title = data.title || "Sprachen";
  const url = data.url || "/";
  event.waitUntil(
    self.registration.showNotification(title, {
      body: data.body || "Time to train!",
      icon: "/icon.svg",
      badge: "/icon.svg",
      tag: "daily-reminder", // collapse repeats into one
      renotify: true,
      data: { url },
    }),
  );
});

// Focus an existing tab (navigating it to the review loop) or open a new one.
self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  const url = (event.notification.data && event.notification.data.url) || "/";
  event.waitUntil(
    self.clients
      .matchAll({ type: "window", includeUncontrolled: true })
      .then((clients) => {
        for (const client of clients) {
          if ("focus" in client) {
            if ("navigate" in client) client.navigate(url).catch(() => {});
            return client.focus();
          }
        }
        return self.clients.openWindow ? self.clients.openWindow(url) : undefined;
      }),
  );
});
