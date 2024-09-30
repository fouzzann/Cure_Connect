import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'couter_event.dart';
part 'couter_state.dart';

class CouterBloc extends Bloc<CouterEvent, CouterState> {
  CouterBloc() : super(CouterInitial()) {
    on<CouterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
