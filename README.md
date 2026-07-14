# GrowRig Official Catalog

The default content catalog shipped with [GrowRig](https://github.com/growrig/growrig):
supported devices, integration bundles, crop species, inventory categories and
vendors. The platform repository links it as a git submodule at `catalog/`.

## Layout

```
catalog.yaml                                  # catalog manifest (see below)
devices/<category>/<device-id>/device.yaml    # device drivers + product variants
integrations/<category>/<id>/integration.yaml # external-service bundles
species/<species-id>/species.yaml             # crop families and stage schemas
inventory/<category-id>/inventory.yaml        # inventory categories (+ products.yaml)
vendors/<vendor-id>/vendor.yaml               # vendor metadata and logos
```

## Manifest

`catalog.yaml` identifies the catalog and declares which content kinds it
provides. Any repository with this manifest and layout can be added to a
GrowRig installation as an additional catalog source (Admin → Catalog), so
you can maintain your own devices or integrations without forking GrowRig:

```yaml
manifest: 1            # manifest schema version
id: my-catalog         # stable id, lowercase and hyphenated
name: My Catalog
description: What this catalog contains.
maintainer: you
homepage: https://github.com/you/my-catalog
provides:              # only list the directories that exist
  - devices
  - integrations
```

See [growrig-catalog-beta](https://github.com/growrig/growrig-catalog-beta)
for a minimal example used to test the custom-source pipeline.

## Contributing

Add a device under `devices/<category>/<device-id>/device.yaml` (categories:
tent, controller, fan, sensor, light, plug, camera, combo) and reference any
product images relative to the device directory. Run the platform's
`make test` with your changes checked out inside the platform repo's
`catalog/` submodule.

## Releasing

The catalog is content-only, so a release is a validated, tagged snapshot — no
build. Note changes under `## Unreleased` in [`CHANGELOG.md`](CHANGELOG.md) as
you go, then from a clean `main`:

```bash
make release VERSION=0.2.0
```

This dates the CHANGELOG section, tags `v0.2.0`, and pushes. CI
([`release.yml`](.github/workflows/release.yml)) re-runs schema validation and
cuts the GitHub Release. The platform pins this repo's submodule to a catalog
tag and refuses to release against anything but the latest one, so releasing
here is what lets new content ship in a platform release.
