import 'package:flutter/material.dart';
import 'package:omni_chat/apis/prompt/get_list.dart';
import 'package:omni_chat/models/api/prompt/prompt_list_res.dart';
import 'package:omni_chat/models/prompt.dart';

class PromptProvider extends ChangeNotifier {
  List<Prompt> publicPrompts;
  List<Prompt> privatePrompts;

  PromptProvider({
    this.publicPrompts = const [],
    this.privatePrompts = const [],
  });

  Future<void> loadPromptList({
    required bool isPublic,
    required String query,
    required String filteredCategory,
    required bool favFiltered,
  }) async {
    PromptListResponse? promptListResponse = await getPromptList(
      isFavorite: favFiltered,
      isPublic: isPublic,
      query: query,
      category: filteredCategory,
    );
    if (promptListResponse != null) {
      if (isPublic) {
        publicPrompts = promptListResponse.items;
      } else {
        privatePrompts = promptListResponse.items;
      }
    }
    notifyListeners();
  }
}
