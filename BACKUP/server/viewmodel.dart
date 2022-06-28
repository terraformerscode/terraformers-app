// import 'package:client/server/api.dart';
// import 'package:client/server/dio_provider.dart';
// import 'package:client/server/irepository.dart';
// import 'package:client/server/message_dto.dart';
// import 'package:client/server/repository.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final viewModelProvider =
//     StateNotifierProvider<ViewModel, AsyncValue<MessageDTO>>(
//   (ref) => ViewModel(Repository(Api(ref.watch(dioProvider)))),
// );

// class ViewModel extends StateNotifier<AsyncValue<MessageDTO>> {
//   ViewModel(this._repository) : super(const AsyncLoading());

//   final IRepository _repository;

//   Future<void> retrieveMessage() async {
//     state = const AsyncLoading();
//     final MessageDTO message = await _repository.retrieveMessage();
//     state = AsyncValue.data(message);
//   }
// }
