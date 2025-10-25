TODO:
- ci prevent outdated codegen
- driver tests
- analytics
- snapshots to have device name attached [device]
- snapshots to have dimensions [width x height]
- readme
- check all samples
- retry
- snapshots to be in global directory, currently test in folder will create another golden path
- snapshots to have enum SnapshotScope { matrix, current }, current method in private
- use configurable logger https://pub.dev/packages/logger instead of printing
- StackTrace print('this is platform ${StackTrace.current.toString()}'); can help creating path for goldens
- ability to provide keys to be awaited disappearance during snapshot tests
- action to go - navigating using router, testing deeplinks etc
- MockHttpRequestHandler doesn't need path if the uri can be uri.path
- Info in wait about gesture detector
- maybe test detect timers in progress and wait for all of them - configurable
- make nav test using ordinary Navigator 2.0 not only GoRouter
- make some mini package with start app Params - location theme as well as initial route
- consider initial route as a '/' instead of null
- consider dropping suite
- go action clearly uses the api inappropriately - should be fixed

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
