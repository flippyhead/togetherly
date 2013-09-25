Package.describe({
  summary: "Addressable library for Meteor."
});

Npm.depends({addressable: '0.3.3'});

Package.on_use(function (api) {
  if (api.export) api.export('Addressable');
  api.add_files(['addressable.js'], 'server');
});