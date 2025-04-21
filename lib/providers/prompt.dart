import 'package:flutter/material.dart';
import 'package:omni_chat/apis/prompt/controllers/get_list.dart';
import 'package:omni_chat/apis/prompt/models/response.dart';
import 'package:omni_chat/models/prompt.dart';

class PromptProvider extends ChangeNotifier {
  List<Prompt> publicPrompts;
  List<Prompt> privatePrompts;
  List<Prompt> slashPrompts;
  String query = "";
  String filteredCategory = "";
  bool favFiltered = false;
  bool publicLoading = false;
  bool privateLoading = false;

  PromptProvider({
    this.publicPrompts = const [],
    this.privatePrompts = const [],
    this.slashPrompts = const [],
  });

  Future<void> getListFromApi({required bool isPublic}) async {
    PromptListResponse? promptListResponse = await getPromptList((
      isFavorite: favFiltered,
      isPublic: isPublic,
      query: query,
      category: filteredCategory,
    ));
    if (promptListResponse != null) {
      if (isPublic) {
        publicPrompts = promptListResponse.items;
      } else {
        privatePrompts = promptListResponse.items;
      }
    }
  }

  void loadList({required bool isPublic}) async {
    if (isPublic) {
      publicLoading = true;
    } else {
      privateLoading = true;
    }
    notifyListeners();
    await getListFromApi(isPublic: isPublic);
    if (isPublic) {
      publicLoading = false;
    } else {
      privateLoading = false;
    }
    notifyListeners();
  }

  void reloadList({required bool isPublic}) async {
    await getListFromApi(isPublic: isPublic);
    notifyListeners();
  }

  bool isListEmpty({required bool isPublic}) {
    if (isPublic) {
      return publicPrompts.isEmpty;
    } else {
      return privatePrompts.isEmpty;
    }
  }

  void load2List() {
    loadList(isPublic: true);
    loadList(isPublic: false);
  }

  void reload2List() {
    reloadList(isPublic: true);
    reloadList(isPublic: false);
  }

  void toggleFavoriteFilter() {
    favFiltered = !favFiltered;
    reload2List();
  }

  void setFilteredCategory(String category) {
    filteredCategory = category;
    reloadList(isPublic: true);
  }

  void searchPrompt(String queryStr) {
    query = queryStr;
    reload2List();
  }

  void initPromptLibrary() {
    publicPrompts = [];
    privatePrompts = [];
    query = "";
    filteredCategory = "";
    favFiltered = false;
    load2List();
  }

  Future<void> loadSlashList() async {
    loadList(isPublic: true);
    loadList(isPublic: false);
    slashPrompts = [...publicPrompts, ...privatePrompts];
    notifyListeners();
  }
}
