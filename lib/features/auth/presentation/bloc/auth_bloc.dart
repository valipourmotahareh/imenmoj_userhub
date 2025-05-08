import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imenmoj_userhub/features/auth/domain/repositories/auth_repository.dart';
import 'package:imenmoj_userhub/features/auth/presentation/bloc/auth_event.dart';
import 'package:imenmoj_userhub/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.login(event.email, event.password);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.register(event.email, event.password, event.name,event.avatarUrl);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await repository.logout();
      emit(AuthInitial());
    });
  }
}