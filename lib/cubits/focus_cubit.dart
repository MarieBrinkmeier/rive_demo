import 'package:bloc/bloc.dart';

class FocusCubit extends Cubit<bool> {
  FocusCubit() : super(true);

  void setFocus(bool hasFocus) {
    emit(hasFocus);
  }
}
