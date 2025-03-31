import 'package:flutter/material.dart';
import 'package:omni_chat/apis/prompt/get_list.dart';
import 'package:omni_chat/models/api/prompt/prompt_list_res.dart';
import 'package:omni_chat/models/prompt.dart';

class PromptProvider extends ChangeNotifier {
  List<Prompt> publicPrompts;
  List<Prompt> privatePrompts;
  String query = "";
  String filteredCategory = "";
  bool favFiltered = false;

  PromptProvider({
    this.publicPrompts = const [],
    this.privatePrompts = const [],
  });

  Future<void> loadList({required bool isPublic}) async {
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

  void load2List() {
    loadList(isPublic: true);
    loadList(isPublic: false);
  }

  void toggleFavoriteFilter() {
    favFiltered = !favFiltered;
    load2List();
  }

  void setFilteredCategory(String category) {
    filteredCategory = category;
    loadList(isPublic: true);
  }

  void searchPrompt(String queryStr) {
    query = queryStr;
    load2List();
  }

  void initPromptProvider() {
    publicPrompts = [];
    privatePrompts = [];
    query = "";
    filteredCategory = "";
    favFiltered = false;
    load2List();
  }
}
