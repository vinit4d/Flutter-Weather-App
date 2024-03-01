part of 'home_cubit.dart';

abstract class HomeState{}



class HomeInitialState extends HomeState{}
class HomeRefreshState extends HomeState{}
class HomeLoadingState extends HomeState{}
class HomeSuccessState extends HomeState{}
class HomeErrorState extends HomeState{
  String msg = "";

  HomeErrorState(this.msg);

}