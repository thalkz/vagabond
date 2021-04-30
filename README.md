# Vagabond

Vagabond is an app for hikers, where areas of the map can be downloaded for offline use. It also shows relevant things, such as hiking routes and nearby shelters.

## Installing

Running the app requires a working [Flutter](https://flutter.dev/) installation.

* `git clone https://github.com/thalkz/vagabond.git`
* `cd vagabond`
* In this directory, create a `.env` file, using the `.env.example` template
* `flutter run`

## Objectives

This project has 3 main goals :

1. Make a working hiking map for personal use
2. Learn to use [supabase](https://supabase.io/) and find improvements for contributing to [supabase-dart](https://github.com/supabase/supabase-dart)
3. Learn advanced Flutter concepts by re-implementing all necessary plugins (other than Supabase)

## Roadmap

* [x] State management
* [x] Environment variables loading
* [x] Map projections & coordinates systems
* [ ] Map rendering
    - [x] Raster tiles
    - [ ] Points
    - [ ] Polylines
* [ ] Fluid map gestures
    - [ ] Drag
    - [ ] Zoom
    - [ ] Pinch
    - [ ] Double Tap
* [ ] Tiles caching using the file system
* [ ] Display user location in realtime (via Android & iOS platform calls)

## References

- https://pub.dev/packages/provider
- https://github.com/xclud/flutter_map
- https://github.com/java-james/flutter_dotenv
- https://www.gr-infos.com/
- https://www.refuges.info/
- https://www.thunderforest.com/