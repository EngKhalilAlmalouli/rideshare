// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:rideshare/model/Settings/change_password_respond.dart';
import 'package:rideshare/model/favourite/favourite_model.dart';
import 'package:rideshare/service/favourite/get_favourite_service.dart';

class GetFavouriteRepo {
  final GetFavouriteService getFavouriteService;
  GetFavouriteRepo({
    required this.getFavouriteService,
  });

  Future<FavouriteModel> getFavouriteRepo() async {
    try {
      var data = await getFavouriteService.getFavouriteService();
      return AllFavouriteRespond.fromMap(data.data);
    } on BadRequest catch (e) {
      return BadFavoriteRespond.fromMap(e.toMap());
    } on DioException catch (e) {
      return ExceptionFavoriteRespond(message: e.response!.data);
    }
  }
}
