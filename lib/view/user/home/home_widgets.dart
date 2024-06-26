import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:medheal/model/doctor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medheal/widgets/text_widgets.dart';
import 'package:medheal/widgets/normal_widgets.dart';
import 'package:medheal/view/user/user_widgets.dart';
import 'package:medheal/widgets/snackbar_widget.dart';
import 'package:medheal/view/user/home/category.dart';
import 'package:medheal/model/appointment_model.dart';
import 'package:medheal/controller/appointment_provider.dart';
import 'package:medheal/controller/notification_provider.dart';
import 'package:medheal/controller/authentication_provider.dart';
import 'package:medheal/view/user/home/notification_screen.dart';
import 'package:medheal/view/user/profile/favourite_doctors.dart';

String formatDate(String date) {
  DateFormat inputFormat = DateFormat('dd/MM/yyyy');
  DateFormat outputFormat = DateFormat('MMMM dd, yyyy');
  DateTime parsedDate = inputFormat.parse(date);
  return outputFormat.format(parsedDate);
}

Widget homeCategoryAvatar(context, imagePath, {category, circleRadius}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryScreen(category: category)));
    },
    child: Column(
      children: [
        CircleAvatar(
          radius: circleRadius,
          backgroundColor:
              const Color.fromARGB(255, 101, 176, 191).withOpacity(0.5),
          child: ClipOval(
            child: Center(
              child: SizedBox(
                width: 40,
                height: 47,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        poppinsText(
          text: category,
          fontSize: 14,
          color: const Color(0xFF101828),
        )
      ],
    ),
  );
}

Widget doctorDetailsExperienceContainer(
    {height, width, valueText, headText, bool rating = false}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color.fromARGB(255, 245, 241, 241),
      ),
      borderRadius: BorderRadius.circular(18),
      color: const Color.fromARGB(255, 245, 241, 241),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          poppinsHeadText(
            textAlign: TextAlign.center,
            text: valueText,
            color: const Color(0xFF1995AD),
            fontSize: 14,
          ),
          const SizedBox(width: 2),
          if (rating)
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 18,
            )
        ]),
        poppinsSmallText(
          textAlign: TextAlign.center,
          text: headText,
          color: const Color(0xFF778293),
        ),
      ],
    ),
  );
}

Widget homeCategory(
  context,
  Size size, {
  circleAvatarRadius,
}) {
  return SizedBox(
    height: size.height * .275,
    width: size.width * .9,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            homeCategoryAvatar(
              context,
              'assets/users.png',
              category: 'General',
              circleRadius: circleAvatarRadius,
            ),
            homeCategoryAvatar(context, 'assets/tooth.png',
                category: 'Dentist', circleRadius: circleAvatarRadius),
            homeCategoryAvatar(context, 'assets/ear.png',
                category: 'Otology', circleRadius: circleAvatarRadius),
            homeCategoryAvatar(context, 'assets/eye.png',
                category: 'Cardiology', circleRadius: circleAvatarRadius),
          ],
        ),
        SizedBox(height: size.height * .01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            homeCategoryAvatar(context, 'assets/small-intestine.png',
                category: 'Intestine', circleRadius: circleAvatarRadius),
            homeCategoryAvatar(context, 'assets/pediatrics.png',
                category: 'Pediatric', circleRadius: circleAvatarRadius),
            homeCategoryAvatar(context, 'assets/herbal-treatment.png',
                category: 'Herbal', circleRadius: circleAvatarRadius),
            homeCategoryAvatar(context, 'assets/more.png',
                category: 'More', circleRadius: circleAvatarRadius),
          ],
        ),
      ],
    ),
  );
}

Widget homeAppBar(Size size, context) {
  final firebaseauth = FirebaseAuth.instance.currentUser;

  ImageProvider? imageprovider;
  if (firebaseauth != null && firebaseauth.photoURL != null) {
    imageprovider = NetworkImage(firebaseauth.photoURL.toString());
  } else {
    imageprovider = const AssetImage("assets/avatar-removebg-preview.png");
  }
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    SizedBox(
      child: Consumer<AuthenticationProvider>(
        builder: (context, value, child) {
          return Row(
            children: [
              CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color.fromARGB(255, 143, 189, 198),
                  backgroundImage: value.currentUser?.image != null
                      ? NetworkImage(value.currentUser?.image ?? '')
                      : imageprovider),
              SizedBox(width: size.width * .02),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                poppinsSmallText(
                  text: 'Welcome',
                  color: const Color.fromARGB(255, 155, 141, 143),
                ),
                poppinsHeadText(
                  text: value.currentUser?.userName!.toUpperCase() ?? 'unknown',
                  color: const Color(0xFF1D1617),
                  fontSize: 14,
                ),
              ]),
            ],
          );
        },
      ),
    ),
    SizedBox(
      child: Row(children: [
        Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
          return IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()));
            },
            icon: Image.asset(
              notificationProvider.hasUnreadNotifications()
                  ? 'assets/notification.png'
                  : 'assets/no_notification.png',
              height: notificationProvider.hasUnreadNotifications() ? 23 : 22,
              width: 25,
            ),
          );
        }),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavouriteDoctorsScreen(),
              ),
            );
          },
          icon: const Icon(EneftyIcons.heart_outline, color: Colors.red),
        ),
      ]),
    ),
  ]);
}

Widget homeUpcomingAppointment(Size size, context, AppointmentModel appointment,
    DoctorModel doctor, circleAvatarFraction) {
  final formattedDate = formatDate(appointment.date ?? '');
  final appointmentProvider =
      Provider.of<AppointmentProvider>(context, listen: false);
  return Center(
    child: Container(
      height: size.height * .19,
      width: size.width * .9,
      decoration: BoxDecoration(
          color: const Color(0xFF1995AD),
          border: Border.all(color: const Color.fromARGB(255, 199, 212, 226)),
          borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: EdgeInsets.only(
          top: size.height * .01,
          bottom: size.height * .01,
          left: size.width * .014,
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ListTile(
            leading: CircleAvatar(
              radius: circleAvatarFraction,
              backgroundColor: const Color(0xFFFFFFFF),
              backgroundImage: doctor.image != null
                  ? NetworkImage(doctor.image!)
                  : const AssetImage('assets/avatar-removebg-preview.png')
                      as ImageProvider,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                poppinsHeadText(
                  text: 'Dr ${doctor.fullName}',
                  color: const Color(0xFFFFFFFF),
                  fontSize: 14,
                ),
                Row(children: [
                  poppinsSmallText(
                    text: '${doctor.age} | ',
                    color: const Color(0xFFFFFFFF),
                  ),
                  poppinsSmallText(
                    text: '${doctor.gender} ',
                    color: const Color(0xFFFFFFFF),
                  ),
                ]),
              ],
            ),
            subtitle: Row(
              children: [
                poppinsSmallText(
                  text: '${doctor.category} | ',
                  color: const Color(0xFFFFFFFF),
                ),
                Flexible(
                  child: poppinsSmallText(
                      text: '${doctor.position} ',
                      color: const Color(0xFFFFFFFF),
                      maxLine: 1,
                      softWrap: true),
                )
              ],
            ),
            trailing: PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                ),
                color: const Color.fromARGB(255, 235, 233, 233),
                onSelected: (value) {
                  if (value == 'reshedule') {
                    appointmentProvider.clearAppointmentControllers();
                    showBottomSheet(
                      context: context,
                      builder: (context) {
                        return showBottom(
                          size,
                          context,
                          appointment: appointment,
                          doctor: doctor,
                        );
                      },
                    );
                  } else if (value == 'cancel') {
                    confirmationDialog(context, size,
                        dialogWidth: size.width * .6,
                        dialogheight: size.height * .16,
                        height: size.height * .02,
                        alertMessage: 'Proceed to cancel Your Appointment ?',
                        confirmText: 'Confirm', onPressedConfirm: () async {
                      await appointmentProvider.cancelAppointment(
                        appointment.id!,
                        (error) {
                          SnackBarWidget().showErrorSnackbar(context, error);
                        },
                      );
                      Navigator.pop(context);
                    });
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        child: poppinsText(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            text: 'Reshedule',
                            color: const Color(0xFF1995AD)),
                        value: 'reshedule'),
                    PopupMenuItem(
                        child: poppinsText(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            text: 'Cancel Booking',
                            color: Colors.red),
                        value: 'cancel'),
                  ];
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 24, 130, 151),
                  ),
                  borderRadius: BorderRadius.circular(18),
                  color: const Color.fromARGB(255, 24, 130, 151),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    'assets/home calendar.png',
                    width: size.width * .1,
                    height: size.height * .055,
                  ),
                  SizedBox(width: size.width * .002),
                  poppinsText(
                    text: formattedDate,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFFFFF),
                  )
                ]),
              ),
              SizedBox(width: size.width * .05),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * .04,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 24, 130, 151),
                  ),
                  borderRadius: BorderRadius.circular(18),
                  color: const Color.fromARGB(255, 24, 130, 151),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    'assets/home time.png',
                    width: size.width * .07,
                    height: size.height * .055,
                  ),
                  SizedBox(width: size.width * .015),
                  poppinsText(
                      text: appointment.time,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFFFFFF))
                ]),
              ),
            ]),
          )
        ]),
      ),
    ),
  );
}

// Widget doctorDetailsTimeButton({
//   VoidCallback? onPressed,
//   time,
//   required bool isSelected,
//   required bool isBooked,
// }) {
//   Color buttonColor = isBooked
//       ? Colors.red
//       : (isSelected ? const Color(0xFF1995AD) : Colors.transparent);
//   Color borderColor = isBooked ? Colors.red.shade300 : Color(0xFF1995AD);
//   return OutlinedButton(
//     style: ButtonStyle(
//       side: WidgetStateProperty.all(
//         BorderSide(color: borderColor, width: 1.2),
//       ),
//       backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
//         if (states.contains(WidgetState.pressed)) {
//           return buttonColor.withOpacity(0.8);
//         } else {
//           return buttonColor;
//         }
//       }),
//     ),
//     onPressed: onPressed,
//     child: poppinsHeadText(
//       textAlign: TextAlign.center,
//       text: time,
//       color: isBooked
//           ? Colors.white
//           : (isSelected ? Colors.white : Color(0xFF1995AD)),
//       fontSize: 14,
//     ),
//   );
// }

Widget doctorDetailsTimeButton({
  VoidCallback? onPressed,
  required String time,
  required bool isSelected,
  required bool isBooked,
}) {
  Color buttonColor = isBooked
      ? Colors.red
      : (isSelected ? const Color(0xFF1995AD) : Colors.transparent);
  Color borderColor = isBooked ? Colors.red.shade300 : Color(0xFF1995AD);

  return OutlinedButton(
    style: ButtonStyle(
      side: WidgetStateProperty.all(
        BorderSide(color: borderColor, width: 1.2),
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return buttonColor.withOpacity(0.8);
        } else {
          return buttonColor;
        }
      }),
    ),
    onPressed: onPressed,
    child: poppinsHeadText(
      textAlign: TextAlign.center,
      text: time,
      color: isBooked
          ? Colors.white
          : (isSelected ? Colors.white : Color(0xFF1995AD)),
      fontSize: 14,
    ),
  );
}

Widget doctorDetailsExperienceRow(Size size, {patient, experience, rating}) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    doctorDetailsExperienceContainer(
        height: size.height * .07,
        width: size.width * .27,
        valueText: patient,
        headText: 'Patients'),
    SizedBox(width: size.width * .04),
    doctorDetailsExperienceContainer(
        height: size.height * .07,
        width: size.width * .27,
        valueText: '$experience Yrs',
        headText: 'Experience'),
    SizedBox(width: size.width * .04),
    doctorDetailsExperienceContainer(
        rating: true,
        height: size.height * .07,
        width: size.width * .27,
        valueText: rating.toString(),
        headText: 'Rating'),
  ]);
}
