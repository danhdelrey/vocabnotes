import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'writing_check_state.dart';

class WritingCheckCubit extends Cubit<WritingCheckState> {
  WritingCheckCubit() : super(WritingCheckInitial());
}
