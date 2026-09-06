import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTagline.
  ///
  /// In es, this message translates to:
  /// **'Cuidado de plantas con IA'**
  String get appTagline;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get signIn;

  /// No description provided for @signInAction.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get signInAction;

  /// No description provided for @welcomeBack.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido de vuelta'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In es, this message translates to:
  /// **'correo@ejemplo.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @passwordMinChars.
  ///
  /// In es, this message translates to:
  /// **'min. 8 caracteres'**
  String get passwordMinChars;

  /// No description provided for @passwordTooShort.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres'**
  String get passwordTooShort;

  /// No description provided for @confirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirma contraseña'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @username.
  ///
  /// In es, this message translates to:
  /// **'Nombre de usuario'**
  String get username;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// No description provided for @noAccountYet.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? '**
  String get noAccountYet;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get alreadyHaveAccount;

  /// No description provided for @enterYourEmail.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa tu correo'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa tu contraseña'**
  String get enterYourPassword;

  /// No description provided for @termsNotice.
  ///
  /// In es, this message translates to:
  /// **'Al registrarte aceptas los Términos de Uso y la Política de Privacidad de ECO2.'**
  String get termsNotice;

  /// No description provided for @navStore.
  ///
  /// In es, this message translates to:
  /// **'Tienda'**
  String get navStore;

  /// No description provided for @navGarden.
  ///
  /// In es, this message translates to:
  /// **'Jardín'**
  String get navGarden;

  /// No description provided for @navDashboard.
  ///
  /// In es, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navScanner.
  ///
  /// In es, this message translates to:
  /// **'Escáner'**
  String get navScanner;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @myGarden.
  ///
  /// In es, this message translates to:
  /// **'Mi Jardín'**
  String get myGarden;

  /// No description provided for @viewAll.
  ///
  /// In es, this message translates to:
  /// **'ver todas'**
  String get viewAll;

  /// No description provided for @addPlant.
  ///
  /// In es, this message translates to:
  /// **'Añadir Planta'**
  String get addPlant;

  /// No description provided for @gardenEmpty.
  ///
  /// In es, this message translates to:
  /// **'Tu jardín está vacío'**
  String get gardenEmpty;

  /// No description provided for @needsWater.
  ///
  /// In es, this message translates to:
  /// **'Riego'**
  String get needsWater;

  /// No description provided for @upToDate.
  ///
  /// In es, this message translates to:
  /// **'Al día'**
  String get upToDate;

  /// No description provided for @noWateringYet.
  ///
  /// In es, this message translates to:
  /// **'Sin riego aún'**
  String get noWateringYet;

  /// No description provided for @wateringToday.
  ///
  /// In es, this message translates to:
  /// **'Riego hoy'**
  String get wateringToday;

  /// No description provided for @wateringOverdue.
  ///
  /// In es, this message translates to:
  /// **'Riego vencido'**
  String get wateringOverdue;

  /// No description provided for @daysWithoutWater.
  ///
  /// In es, this message translates to:
  /// **'días sin riego'**
  String get daysWithoutWater;

  /// No description provided for @daysInYourGarden.
  ///
  /// In es, this message translates to:
  /// **'días en tu jardín'**
  String get daysInYourGarden;

  /// No description provided for @frequency.
  ///
  /// In es, this message translates to:
  /// **'frecuencia'**
  String get frequency;

  /// No description provided for @remaining.
  ///
  /// In es, this message translates to:
  /// **'restantes'**
  String get remaining;

  /// No description provided for @overdue.
  ///
  /// In es, this message translates to:
  /// **'vencido'**
  String get overdue;

  /// No description provided for @careStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado de cuidado'**
  String get careStatus;

  /// No description provided for @urgentWatering.
  ///
  /// In es, this message translates to:
  /// **'Riego Urgente'**
  String get urgentWatering;

  /// No description provided for @deletePlantTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar planta?'**
  String get deletePlantTitle;

  /// No description provided for @deletePlantBody.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará \"{plantName}\" de tu jardín. Esta acción no se puede deshacer.'**
  String deletePlantBody(String plantName);

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @lastWateredQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo regaste {plantName} por última vez?'**
  String lastWateredQuestion(String plantName);

  /// No description provided for @lastWateredHelp.
  ///
  /// In es, this message translates to:
  /// **'Así calculamos cuándo toca el próximo riego. Si no lo sabes, empezamos a contar desde hoy.'**
  String get lastWateredHelp;

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In es, this message translates to:
  /// **'Ayer'**
  String get yesterday;

  /// No description provided for @someDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace unos días…'**
  String get someDaysAgo;

  /// No description provided for @neverOrDontRemember.
  ///
  /// In es, this message translates to:
  /// **'Nunca / no lo recuerdo'**
  String get neverOrDontRemember;

  /// No description provided for @lastWatering.
  ///
  /// In es, this message translates to:
  /// **'Último riego'**
  String get lastWatering;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In es, this message translates to:
  /// **'CUENTA'**
  String get account;

  /// No description provided for @editProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Nombre, bio, foto'**
  String get editProfileSubtitle;

  /// No description provided for @changePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get changePassword;

  /// No description provided for @biometricAuth.
  ///
  /// In es, this message translates to:
  /// **'Autenticación biométrica'**
  String get biometricAuth;

  /// No description provided for @notifications.
  ///
  /// In es, this message translates to:
  /// **'NOTIFICACIONES'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones push'**
  String get pushNotifications;

  /// No description provided for @wateringReminders.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios de riego'**
  String get wateringReminders;

  /// No description provided for @achievementsAndMissions.
  ///
  /// In es, this message translates to:
  /// **'Logros y misiones'**
  String get achievementsAndMissions;

  /// No description provided for @preferences.
  ///
  /// In es, this message translates to:
  /// **'PREFERENCIAS'**
  String get preferences;

  /// No description provided for @systemLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma del sistema'**
  String get systemLanguage;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @themeAndColors.
  ///
  /// In es, this message translates to:
  /// **'Tema y colores'**
  String get themeAndColors;

  /// No description provided for @privacyAndData.
  ///
  /// In es, this message translates to:
  /// **'PRIVACIDAD Y DATOS'**
  String get privacyAndData;

  /// No description provided for @privacy.
  ///
  /// In es, this message translates to:
  /// **'Privacidad'**
  String get privacy;

  /// No description provided for @privacySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Control de datos personales'**
  String get privacySubtitle;

  /// No description provided for @exportMyData.
  ///
  /// In es, this message translates to:
  /// **'Exportar mis datos'**
  String get exportMyData;

  /// No description provided for @application.
  ///
  /// In es, this message translates to:
  /// **'APLICACIÓN'**
  String get application;

  /// No description provided for @helpAndSupport.
  ///
  /// In es, this message translates to:
  /// **'Ayuda y soporte'**
  String get helpAndSupport;

  /// No description provided for @aboutEco2.
  ///
  /// In es, this message translates to:
  /// **'Sobre ECO2'**
  String get aboutEco2;

  /// No description provided for @dangerZone.
  ///
  /// In es, this message translates to:
  /// **'ZONA DE RIESGO'**
  String get dangerZone;

  /// No description provided for @signOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es permanente'**
  String get deleteAccountSubtitle;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @plants.
  ///
  /// In es, this message translates to:
  /// **'Plantas'**
  String get plants;

  /// No description provided for @seeds.
  ///
  /// In es, this message translates to:
  /// **'Semillas'**
  String get seeds;

  /// No description provided for @co2Total.
  ///
  /// In es, this message translates to:
  /// **'CO₂ total'**
  String get co2Total;

  /// No description provided for @levelLabel.
  ///
  /// In es, this message translates to:
  /// **'Nivel {level}'**
  String levelLabel(int level);

  /// No description provided for @levelWithName.
  ///
  /// In es, this message translates to:
  /// **'Nivel {level} · {name}'**
  String levelWithName(int level, String name);

  /// No description provided for @myTrophies.
  ///
  /// In es, this message translates to:
  /// **'Mis Trofeos'**
  String get myTrophies;

  /// No description provided for @trophies.
  ///
  /// In es, this message translates to:
  /// **'Trofeos'**
  String get trophies;

  /// No description provided for @missions.
  ///
  /// In es, this message translates to:
  /// **'Misiones'**
  String get missions;

  /// No description provided for @achievements.
  ///
  /// In es, this message translates to:
  /// **'Logros'**
  String get achievements;

  /// No description provided for @obtained.
  ///
  /// In es, this message translates to:
  /// **'Obtenidos'**
  String get obtained;

  /// No description provided for @available.
  ///
  /// In es, this message translates to:
  /// **'Disponibles'**
  String get available;

  /// No description provided for @completedPercent.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get completedPercent;

  /// No description provided for @streakDays.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 día seguido} other{{count} días seguidos}}'**
  String streakDays(int count);

  /// No description provided for @xpPoints.
  ///
  /// In es, this message translates to:
  /// **'{xp} XP'**
  String xpPoints(int xp);

  /// No description provided for @seedsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} semillas'**
  String seedsCount(int count);

  /// No description provided for @greenFootprint.
  ///
  /// In es, this message translates to:
  /// **'Mi Huella Verde'**
  String get greenFootprint;

  /// No description provided for @co2AbsorbedToday.
  ///
  /// In es, this message translates to:
  /// **'CO₂ absorbido hoy'**
  String get co2AbsorbedToday;

  /// No description provided for @gramsPerDay.
  ///
  /// In es, this message translates to:
  /// **'gramos / día'**
  String get gramsPerDay;

  /// No description provided for @contributionPerPlant.
  ///
  /// In es, this message translates to:
  /// **'Aporte por planta'**
  String get contributionPerPlant;

  /// No description provided for @weeklyEvolution.
  ///
  /// In es, this message translates to:
  /// **'Evolución semanal'**
  String get weeklyEvolution;

  /// No description provided for @weeklyEvolutionHelp.
  ///
  /// In es, this message translates to:
  /// **'Refleja cuándo entró cada planta a tu jardín.'**
  String get weeklyEvolutionHelp;

  /// No description provided for @copyMyFootprint.
  ///
  /// In es, this message translates to:
  /// **'Copiar mi huella verde'**
  String get copyMyFootprint;

  /// No description provided for @copiedToClipboard.
  ///
  /// In es, this message translates to:
  /// **'Copiado al portapapeles'**
  String get copiedToClipboard;

  /// No description provided for @accumulated.
  ///
  /// In es, this message translates to:
  /// **'Acumulado: {kg} kg'**
  String accumulated(String kg);

  /// No description provided for @noPlantsYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes plantas en tu jardín'**
  String get noPlantsYet;

  /// No description provided for @footprintError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos calcular tu huella verde.'**
  String get footprintError;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @scannerPointAtPlant.
  ///
  /// In es, this message translates to:
  /// **'Apunta a una planta'**
  String get scannerPointAtPlant;

  /// No description provided for @scannerAnalyzing.
  ///
  /// In es, this message translates to:
  /// **'Analizando...'**
  String get scannerAnalyzing;

  /// No description provided for @scannerNotInCatalog.
  ///
  /// In es, this message translates to:
  /// **'La reconocimos, pero todavía no está en el catálogo de ECO2 — no podemos añadirla a tu jardín todavía.'**
  String get scannerNotInCatalog;

  /// No description provided for @scannerLowConfidence.
  ///
  /// In es, this message translates to:
  /// **'No pudimos reconocerla con suficiente confianza. Prueba con más luz o de más cerca.'**
  String get scannerLowConfidence;

  /// No description provided for @connectionError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión. Verifica tu internet.'**
  String get connectionError;

  /// No description provided for @wrongCredentials.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos.'**
  String get wrongCredentials;

  /// No description provided for @emailAlreadyUsed.
  ///
  /// In es, this message translates to:
  /// **'Este correo ya tiene una cuenta registrada.'**
  String get emailAlreadyUsed;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @greeting.
  ///
  /// In es, this message translates to:
  /// **'Namasté'**
  String get greeting;

  /// No description provided for @yourSeeds.
  ///
  /// In es, this message translates to:
  /// **'Tus semillas'**
  String get yourSeeds;

  /// No description provided for @activeMission.
  ///
  /// In es, this message translates to:
  /// **'Misión Activa'**
  String get activeMission;

  /// No description provided for @searchSpecies.
  ///
  /// In es, this message translates to:
  /// **'Buscar especie...'**
  String get searchSpecies;

  /// No description provided for @searchMyPlant.
  ///
  /// In es, this message translates to:
  /// **'Buscar mi planta...'**
  String get searchMyPlant;

  /// No description provided for @exploreSpecies.
  ///
  /// In es, this message translates to:
  /// **'Explorar especies'**
  String get exploreSpecies;

  /// No description provided for @trendingThisWeek.
  ///
  /// In es, this message translates to:
  /// **'Tendencias esta semana'**
  String get trendingThisWeek;

  /// No description provided for @allCategory.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get allCategory;

  /// No description provided for @plantsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} plantas'**
  String plantsCount(int count);

  /// No description provided for @needsAttentionToday.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 planta necesita atención hoy} other{{count} plantas necesitan atención hoy}}'**
  String needsAttentionToday(int count);

  /// No description provided for @view.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get view;

  /// No description provided for @add.
  ///
  /// In es, this message translates to:
  /// **'Añadir'**
  String get add;

  /// No description provided for @allUpToDate.
  ///
  /// In es, this message translates to:
  /// **'¡Todo al día!'**
  String get allUpToDate;

  /// No description provided for @wateringStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado de riego'**
  String get wateringStatus;

  /// No description provided for @logEveryCare.
  ///
  /// In es, this message translates to:
  /// **'Registra cada cuidado'**
  String get logEveryCare;

  /// No description provided for @viewHistory.
  ///
  /// In es, this message translates to:
  /// **'Ver historial'**
  String get viewHistory;

  /// No description provided for @latestCare.
  ///
  /// In es, this message translates to:
  /// **'Últimos cuidados'**
  String get latestCare;

  /// No description provided for @careType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de cuidado'**
  String get careType;

  /// No description provided for @suggestedNextWatering.
  ///
  /// In es, this message translates to:
  /// **'Próximo riego sugerido'**
  String get suggestedNextWatering;

  /// No description provided for @inMyCollectionSince.
  ///
  /// In es, this message translates to:
  /// **'En mi colección desde'**
  String get inMyCollectionSince;

  /// No description provided for @howToCareTitle.
  ///
  /// In es, this message translates to:
  /// **'Cómo cuidar tu planta'**
  String get howToCareTitle;

  /// No description provided for @everyNDays.
  ///
  /// In es, this message translates to:
  /// **'Cada {days} días'**
  String everyNDays(int days);

  /// No description provided for @daysAgo.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{hace 1 día} other{hace {count} días}}'**
  String daysAgo(int count);

  /// No description provided for @noCareLogged.
  ///
  /// In es, this message translates to:
  /// **'Aún no has registrado cuidados.'**
  String get noCareLogged;

  /// No description provided for @scannerHint.
  ///
  /// In es, this message translates to:
  /// **'Apunta a una planta'**
  String get scannerHint;

  /// No description provided for @analyzing.
  ///
  /// In es, this message translates to:
  /// **'Analizando...'**
  String get analyzing;

  /// No description provided for @notIdentified.
  ///
  /// In es, this message translates to:
  /// **'No identificada con certeza'**
  String get notIdentified;

  /// No description provided for @potsRemaining.
  ///
  /// In es, this message translates to:
  /// **'Macetas restantes: {count}'**
  String potsRemaining(int count);

  /// No description provided for @notificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsTitle;

  /// No description provided for @markAllRead.
  ///
  /// In es, this message translates to:
  /// **'Marcar todas como leídas'**
  String get markAllRead;

  /// No description provided for @todayLabel.
  ///
  /// In es, this message translates to:
  /// **'HOY'**
  String get todayLabel;

  /// No description provided for @thatsAllForNow.
  ///
  /// In es, this message translates to:
  /// **'Eso es todo por ahora'**
  String get thatsAllForNow;

  /// No description provided for @noNotifications.
  ///
  /// In es, this message translates to:
  /// **'No tienes notificaciones'**
  String get noNotifications;

  /// No description provided for @wateringPending.
  ///
  /// In es, this message translates to:
  /// **'Riego pendiente'**
  String get wateringPending;

  /// No description provided for @achievementUnlocked.
  ///
  /// In es, this message translates to:
  /// **'¡Logro desbloqueado!'**
  String get achievementUnlocked;

  /// No description provided for @newPlantAdded.
  ///
  /// In es, this message translates to:
  /// **'Nueva planta agregada'**
  String get newPlantAdded;

  /// No description provided for @seedbed.
  ///
  /// In es, this message translates to:
  /// **'Semillero'**
  String get seedbed;

  /// No description provided for @redeemSeeds.
  ///
  /// In es, this message translates to:
  /// **'Canjea tus semillas por recompensas'**
  String get redeemSeeds;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get search;

  /// No description provided for @communityFavorites.
  ///
  /// In es, this message translates to:
  /// **'Los favoritos de la comunidad'**
  String get communityFavorites;

  /// No description provided for @newBadge.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get newBadge;

  /// No description provided for @yourImpactEquals.
  ///
  /// In es, this message translates to:
  /// **'Tu impacto equivale a:'**
  String get yourImpactEquals;

  /// No description provided for @treesEquivalent.
  ///
  /// In es, this message translates to:
  /// **'{count} Árboles'**
  String treesEquivalent(int count);

  /// No description provided for @kilometersEquivalent.
  ///
  /// In es, this message translates to:
  /// **'{count} Kilómetros'**
  String kilometersEquivalent(int count);

  /// No description provided for @levelAndTrophies.
  ///
  /// In es, this message translates to:
  /// **'Nivel {level} · {trophies} trofeos'**
  String levelAndTrophies(int level, int trophies);

  /// No description provided for @noAchievementsYet.
  ///
  /// In es, this message translates to:
  /// **'No has completado logros todavía.'**
  String get noAchievementsYet;

  /// No description provided for @allAchievementsDone.
  ///
  /// In es, this message translates to:
  /// **'¡Ya desbloqueaste todos los logros!'**
  String get allAchievementsDone;

  /// No description provided for @noAchievementsConfigured.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay logros configurados.'**
  String get noAchievementsConfigured;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get comingSoon;

  /// No description provided for @reward.
  ///
  /// In es, this message translates to:
  /// **'Recompensa'**
  String get reward;

  /// No description provided for @achievementUnlockedLabel.
  ///
  /// In es, this message translates to:
  /// **'Logro desbloqueado'**
  String get achievementUnlockedLabel;

  /// No description provided for @achievementLockedLabel.
  ///
  /// In es, this message translates to:
  /// **'Logro bloqueado'**
  String get achievementLockedLabel;

  /// No description provided for @activeMissions.
  ///
  /// In es, this message translates to:
  /// **'Misiones Activas'**
  String get activeMissions;

  /// No description provided for @plantCatalog.
  ///
  /// In es, this message translates to:
  /// **'Catálogo de Plantas'**
  String get plantCatalog;

  /// No description provided for @seedStore.
  ///
  /// In es, this message translates to:
  /// **'Tienda de Semillas'**
  String get seedStore;

  /// No description provided for @freePlanActive.
  ///
  /// In es, this message translates to:
  /// **'Plan gratuito activo'**
  String get freePlanActive;

  /// No description provided for @user.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get user;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @genericError.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal. Inténtalo de nuevo.'**
  String get genericError;

  /// No description provided for @catTropical.
  ///
  /// In es, this message translates to:
  /// **'Tropical'**
  String get catTropical;

  /// No description provided for @catSucculent.
  ///
  /// In es, this message translates to:
  /// **'Suculenta'**
  String get catSucculent;

  /// No description provided for @catCactus.
  ///
  /// In es, this message translates to:
  /// **'Cactus'**
  String get catCactus;

  /// No description provided for @catFern.
  ///
  /// In es, this message translates to:
  /// **'Helecho'**
  String get catFern;

  /// No description provided for @catFlowering.
  ///
  /// In es, this message translates to:
  /// **'Con flores'**
  String get catFlowering;

  /// No description provided for @catHerb.
  ///
  /// In es, this message translates to:
  /// **'Aromática'**
  String get catHerb;

  /// No description provided for @catTree.
  ///
  /// In es, this message translates to:
  /// **'Árbol'**
  String get catTree;

  /// No description provided for @catOther.
  ///
  /// In es, this message translates to:
  /// **'Planta'**
  String get catOther;

  /// No description provided for @lightLow.
  ///
  /// In es, this message translates to:
  /// **'Baja'**
  String get lightLow;

  /// No description provided for @lightMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get lightMedium;

  /// No description provided for @lightHigh.
  ///
  /// In es, this message translates to:
  /// **'Alta'**
  String get lightHigh;

  /// No description provided for @lightIndirect.
  ///
  /// In es, this message translates to:
  /// **'Indirecta'**
  String get lightIndirect;

  /// No description provided for @lightPrefix.
  ///
  /// In es, this message translates to:
  /// **'Luz {level}'**
  String lightPrefix(String level);

  /// No description provided for @difficultyVeryEasy.
  ///
  /// In es, this message translates to:
  /// **'Muy fácil'**
  String get difficultyVeryEasy;

  /// No description provided for @difficultyEasy.
  ///
  /// In es, this message translates to:
  /// **'Fácil'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get difficultyMedium;

  /// No description provided for @wateringEveryDays.
  ///
  /// In es, this message translates to:
  /// **'Riego c/{days}d'**
  String wateringEveryDays(int days);

  /// No description provided for @humidityLow.
  ///
  /// In es, this message translates to:
  /// **'Baja'**
  String get humidityLow;

  /// No description provided for @humidityMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get humidityMedium;

  /// No description provided for @humidityHigh.
  ///
  /// In es, this message translates to:
  /// **'Alta'**
  String get humidityHigh;

  /// No description provided for @impactCarTitle.
  ///
  /// In es, this message translates to:
  /// **'{km} km en coche'**
  String impactCarTitle(String km);

  /// No description provided for @impactCarSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Que no haría falta conducir para emitir ese CO₂.'**
  String get impactCarSubtitle;

  /// No description provided for @impactBulbTitle.
  ///
  /// In es, this message translates to:
  /// **'{hours} h de bombilla LED'**
  String impactBulbTitle(String hours);

  /// No description provided for @impactBulbSubtitle.
  ///
  /// In es, this message translates to:
  /// **'De consumo eléctrico equivalente.'**
  String get impactBulbSubtitle;

  /// No description provided for @impactTreeTitle.
  ///
  /// In es, this message translates to:
  /// **'{days} días de un árbol'**
  String impactTreeTitle(String days);

  /// No description provided for @impactTreeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Lo que tarda un árbol adulto en absorber lo mismo.'**
  String get impactTreeSubtitle;

  /// No description provided for @impactApproxNote.
  ///
  /// In es, this message translates to:
  /// **'Equivalencias aproximadas, calculadas a partir del CO₂ de tu jardín.'**
  String get impactApproxNote;

  /// No description provided for @impactTooSmall.
  ///
  /// In es, this message translates to:
  /// **'Tu jardín aún no acumula CO₂ suficiente para una equivalencia útil.'**
  String get impactTooSmall;

  /// No description provided for @accumulatedGrams.
  ///
  /// In es, this message translates to:
  /// **'Acumulado: {grams} g'**
  String accumulatedGrams(String grams);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
