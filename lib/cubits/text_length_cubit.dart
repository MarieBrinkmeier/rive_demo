import 'package:bloc/bloc.dart';

class TextLengthCubit extends Cubit<double> {
  TextLengthCubit() : super(0);

  void changeLength(double length) {
    emit(length);
  }
}
