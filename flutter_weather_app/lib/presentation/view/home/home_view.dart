import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/config/extenstions/imagePaths.dart';
import 'package:flutter_weather_app/presentation/theme/theme_config.dart';
import 'package:flutter_weather_app/presentation/view/home/cubit/home_cubit.dart';
import 'package:lottie/lottie.dart';

import '../../../config/app_route.dart';
import '../../../data/local_services/cache_services.dart';
import '../../../domain/entity/current_weather_entity.dart';
import '../../widget/alertbox.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = context.watch<HomeCubit>();
    return Scaffold(
      backgroundColor: Colors.black12,
      body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is HomeInitialState) {
              cubit.getCurrentLocation();
            }
            if (state is HomeLoadingState) {
              return Center(
                child: SizedBox(
                    height: 200,
                    width: 400,
                    child: Lottie.asset("loader".toLottie)),
              );
            }

            if (state is HomeSuccessState) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage(cubit.weatherImg(cubit.list[0].main).toPng),
                    // Replace with your image asset
                    fit: BoxFit.cover,
                  ),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 50, bottom: 10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                              height: 200,
                              width: 400,
                              child: Lottie.asset(cubit
                                  .weatherImg(cubit.list[0].main)
                                  .toLottie)),
                          Positioned(
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  AlertBox.showAlertDialog(
                                      context: context,
                                      title: "Are you sure?",
                                      child: Text(
                                        "Do you want to Logout from App?",
                                        style: ThemeConfig.dimens.width > 500
                                            ? ThemeConfig.styles.style08
                                            : ThemeConfig.styles.style12,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: Text(
                                              "No",
                                              style: ThemeConfig.styles.style14
                                                  .copyWith(
                                                      color: ThemeConfig
                                                          .colors.primary),
                                            )),
                                        TextButton(
                                            onPressed: () async {
                                              await CacheService
                                                  .removeAppUser();
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                AppRoute.signInRoute,
                                                (Route route) => false,
                                              );
                                            },
                                            child: Text(
                                              "Yes",
                                              style: ThemeConfig.styles.style14
                                                  .copyWith(
                                                      color: ThemeConfig
                                                          .colors.red),
                                            )),
                                      ]);
                                },
                                icon: Icon(
                                  Icons.logout_outlined,
                                  size:
                                      ThemeConfig.dimens.width > 500 ? 40 : 20,
                                  color: ThemeConfig.colors.primary,
                                )),
                          ),
                          Positioned(
                            bottom: 0,
                            right: ThemeConfig.dimens.width / 2.6,
                            child: Text(
                              cubit.list[0].main.toString(),
                              style: ThemeConfig.styles.style28.copyWith(
                                  color: ThemeConfig.colors.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${cubit.convertCelsius(cubit.list[0].temp!)}\u00B0',
                        style: ThemeConfig.styles.style28.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ThemeConfig.colors.whiteColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                            text: ' ${cubit.city},',
                            style: ThemeConfig.styles.style14.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ThemeConfig.colors.whiteColor),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' ${cubit.country}',
                                style: ThemeConfig.styles.style12.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: ThemeConfig.colors.whiteColor
                                        .withOpacity(0.8)),
                              )
                            ]),
                      ),
                      Text(
                        cubit.dateConvert(cubit.list[0].dtTxt),
                        style: ThemeConfig.styles.style14.copyWith(
                            fontWeight: FontWeight.w400,
                            color: ThemeConfig.colors.whiteColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black38),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text("Wind",
                                        style: ThemeConfig.styles.style12
                                            .copyWith(
                                                color: Colors.grey
                                                    .withOpacity(0.9))),
                                    Text(
                                      "${cubit.list[0].wind} Km/h",
                                      style: ThemeConfig.styles.style12
                                          .copyWith(
                                              color: ThemeConfig
                                                  .colors.whiteColor),
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  color: Colors.black,
                                  thickness: 2,
                                ),
                                Column(
                                  children: [
                                    Text("Humidity",
                                        style: ThemeConfig.styles.style12
                                            .copyWith(
                                                color: Colors.grey
                                                    .withOpacity(0.9))),
                                    Text(
                                      "${cubit.list[0].humidity}%",
                                      style: ThemeConfig.styles.style12
                                          .copyWith(
                                              color: ThemeConfig
                                                  .colors.whiteColor),
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  color: Colors.black,
                                  thickness: 2,
                                ),
                                Column(
                                  children: [
                                    Text("Visibility",
                                        style: ThemeConfig.styles.style12
                                            .copyWith(
                                                color: Colors.grey
                                                    .withOpacity(0.9))),
                                    Text(
                                      "${cubit.list[0].visibility}",
                                      style: ThemeConfig.styles.style12
                                          .copyWith(
                                              color: ThemeConfig
                                                  .colors.whiteColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                cubit.toggleDays("Today");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: Center(child: Text("Today")),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                cubit.toggleDays("Tomorrow");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ThemeConfig.colors.whiteColor),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.transparent),
                                child: Center(
                                    child: Text(
                                  "Tomorrow",
                                  style: ThemeConfig.styles.style12.copyWith(
                                      color: ThemeConfig.colors.whiteColor),
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                cubit.toggleDays("7 Days");
                                cubit.getWeekWeatherReport();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ThemeConfig.colors.whiteColor),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.transparent),
                                child: Center(
                                    child: Text("7 Days",
                                        style: ThemeConfig.styles.style12
                                            .copyWith(
                                                color: ThemeConfig
                                                    .colors.whiteColor))),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                          height: 200,
                          width: ThemeConfig.dimens.width,
                          child: Swiper(
                            index: 2,
                            itemBuilder: (BuildContext context, int index) {

                            var data = cubit.searchAccordingName(cubit.day)[index];

                            if(cubit.day == '7 Days'){
                              data = cubit.searchAccordingName(cubit.day)[index+1];
                            }
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 15),
                                child: Container(
                                  height: 100,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: ThemeConfig.colors.whiteColor,
                                    // image: DecorationImage(image: AssetImage('sunny'.toPng)),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Lottie.asset(cubit
                                              .weatherImg(
                                              data.main)
                                              .toLottie)),
                                      Text(
                                        '${cubit.convertCelsius(data.temp!)}\u00B0',
                                        style: ThemeConfig.styles.style28
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: ThemeConfig
                                                    .colors.brownColor
                                                    .withOpacity(0.9)),
                                      ),
                                      Text(
                                        cubit.day == '7 Days'?
                                        cubit.getDayOfWeek(data.dtTxt!)

                                        :
                                        cubit.timeConvert(data.dtTxt!),
                                        style:
                                            ThemeConfig.styles.style14.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount:
                            cubit.day == '7 Days'?
                            cubit.searchAccordingName(cubit.day)
                                .length-1:cubit.searchAccordingName(cubit.day)
                                .length,
                            viewportFraction: 0.3,
                            scale: 0.2,
                            loop: false,
                            customLayoutOption: CustomLayoutOption(
                              startIndex: 1,
                              stateCount: 2,
                            ),
                            transformer: ScaleAndFadeTransformer(),
                            // pagination: SwiperPagination(),
                            // control: SwiperControl(),
                          )),


                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
    );
  }
}
