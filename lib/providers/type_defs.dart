import 'package:fpdart/fpdart.dart';
import 'package:reddit/providers/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = Future<Either<Failure, void>>;