// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTagline => 'Cuidado de plantas con IA';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signInAction => 'Iniciar sesión';

  @override
  String get welcomeBack => 'Bienvenido de vuelta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailHint => 'correo@ejemplo.com';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordMinChars => 'min. 8 caracteres';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get confirmPassword => 'Confirma contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get register => 'Registrarse';

  @override
  String get noAccountYet => '¿No tienes cuenta? ';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get enterYourEmail => 'Por favor ingresa tu correo';

  @override
  String get enterYourPassword => 'Por favor ingresa tu contraseña';

  @override
  String get termsNotice =>
      'Al registrarte aceptas los Términos de Uso y la Política de Privacidad de ECO2.';

  @override
  String get navStore => 'Tienda';

  @override
  String get navGarden => 'Jardín';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navScanner => 'Escáner';

  @override
  String get navProfile => 'Perfil';

  @override
  String get myGarden => 'Mi Jardín';

  @override
  String get viewAll => 'ver todas';

  @override
  String get addPlant => 'Añadir Planta';

  @override
  String get gardenEmpty => 'Tu jardín está vacío';

  @override
  String get needsWater => 'Riego';

  @override
  String get upToDate => 'Al día';

  @override
  String get noWateringYet => 'Sin riego aún';

  @override
  String get wateringToday => 'Riego hoy';

  @override
  String get wateringOverdue => 'Riego vencido';

  @override
  String get daysWithoutWater => 'días sin riego';

  @override
  String get daysInYourGarden => 'días en tu jardín';

  @override
  String get frequency => 'frecuencia';

  @override
  String get remaining => 'restantes';

  @override
  String get overdue => 'vencido';

  @override
  String get careStatus => 'Estado de cuidado';

  @override
  String get urgentWatering => 'Riego Urgente';

  @override
  String get deletePlantTitle => '¿Eliminar planta?';

  @override
  String deletePlantBody(String plantName) {
    return 'Se eliminará \"$plantName\" de tu jardín. Esta acción no se puede deshacer.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String lastWateredQuestion(String plantName) {
    return '¿Cuándo regaste $plantName por última vez?';
  }

  @override
  String get lastWateredHelp =>
      'Así calculamos cuándo toca el próximo riego. Si no lo sabes, empezamos a contar desde hoy.';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get someDaysAgo => 'Hace unos días…';

  @override
  String get neverOrDontRemember => 'Nunca / no lo recuerdo';

  @override
  String get lastWatering => 'Último riego';

  @override
  String get settings => 'Ajustes';

  @override
  String get account => 'CUENTA';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get editProfileSubtitle => 'Nombre, bio, foto';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get biometricAuth => 'Autenticación biométrica';

  @override
  String get notifications => 'NOTIFICACIONES';

  @override
  String get pushNotifications => 'Notificaciones push';

  @override
  String get wateringReminders => 'Recordatorios de riego';

  @override
  String get achievementsAndMissions => 'Logros y misiones';

  @override
  String get preferences => 'PREFERENCIAS';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get language => 'Idioma';

  @override
  String get themeAndColors => 'Tema y colores';

  @override
  String get privacyAndData => 'PRIVACIDAD Y DATOS';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacySubtitle => 'Control de datos personales';

  @override
  String get exportMyData => 'Exportar mis datos';

  @override
  String get application => 'APLICACIÓN';

  @override
  String get helpAndSupport => 'Ayuda y soporte';

  @override
  String get aboutEco2 => 'Sobre ECO2';

  @override
  String get dangerZone => 'ZONA DE RIESGO';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountSubtitle => 'Esta acción es permanente';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get profile => 'Perfil';

  @override
  String get plants => 'Plantas';

  @override
  String get seeds => 'Semillas';

  @override
  String get co2Total => 'CO₂ total';

  @override
  String levelLabel(int level) {
    return 'Nivel $level';
  }

  @override
  String levelWithName(int level, String name) {
    return 'Nivel $level · $name';
  }

  @override
  String get myTrophies => 'Mis Trofeos';

  @override
  String get trophies => 'Trofeos';

  @override
  String get missions => 'Misiones';

  @override
  String get achievements => 'Logros';

  @override
  String get obtained => 'Obtenidos';

  @override
  String get available => 'Disponibles';

  @override
  String get completedPercent => 'Completado';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días seguidos',
      one: '1 día seguido',
    );
    return '$_temp0';
  }

  @override
  String xpPoints(int xp) {
    return '$xp XP';
  }

  @override
  String seedsCount(int count) {
    return '$count semillas';
  }

  @override
  String get greenFootprint => 'Mi Huella Verde';

  @override
  String get co2AbsorbedToday => 'CO₂ absorbido hoy';

  @override
  String get gramsPerDay => 'gramos / día';

  @override
  String get contributionPerPlant => 'Aporte por planta';

  @override
  String get weeklyEvolution => 'Evolución semanal';

  @override
  String get weeklyEvolutionHelp =>
      'Refleja cuándo entró cada planta a tu jardín.';

  @override
  String get copyMyFootprint => 'Copiar mi huella verde';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String accumulated(String kg) {
    return 'Acumulado: $kg kg';
  }

  @override
  String get noPlantsYet => 'Aún no tienes plantas en tu jardín';

  @override
  String get footprintError => 'No pudimos calcular tu huella verde.';

  @override
  String get retry => 'Reintentar';

  @override
  String get scannerPointAtPlant => 'Apunta a una planta';

  @override
  String get scannerAnalyzing => 'Analizando...';

  @override
  String get scannerNotInCatalog =>
      'La reconocimos, pero todavía no está en el catálogo de ECO2 — no podemos añadirla a tu jardín todavía.';

  @override
  String get scannerLowConfidence =>
      'No pudimos reconocerla con suficiente confianza. Prueba con más luz o de más cerca.';

  @override
  String get connectionError => 'Error de conexión. Verifica tu internet.';

  @override
  String get wrongCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get emailAlreadyUsed => 'Este correo ya tiene una cuenta registrada.';

  @override
  String get save => 'Guardar';

  @override
  String get close => 'Cerrar';

  @override
  String get greeting => 'Namasté';

  @override
  String get yourSeeds => 'Tus semillas';

  @override
  String get activeMission => 'Misión Activa';

  @override
  String get searchSpecies => 'Buscar especie...';

  @override
  String get searchMyPlant => 'Buscar mi planta...';

  @override
  String get exploreSpecies => 'Explorar especies';

  @override
  String get trendingThisWeek => 'Tendencias esta semana';

  @override
  String get allCategory => 'Todas';

  @override
  String plantsCount(int count) {
    return '$count plantas';
  }

  @override
  String needsAttentionToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plantas necesitan atención hoy',
      one: '1 planta necesita atención hoy',
    );
    return '$_temp0';
  }

  @override
  String get view => 'Ver';

  @override
  String get add => 'Añadir';

  @override
  String get allUpToDate => '¡Todo al día!';

  @override
  String get wateringStatus => 'Estado de riego';

  @override
  String get logEveryCare => 'Registra cada cuidado';

  @override
  String get viewHistory => 'Ver historial';

  @override
  String get latestCare => 'Últimos cuidados';

  @override
  String get careType => 'Tipo de cuidado';

  @override
  String get suggestedNextWatering => 'Próximo riego sugerido';

  @override
  String get inMyCollectionSince => 'En mi colección desde';

  @override
  String get howToCareTitle => 'Cómo cuidar tu planta';

  @override
  String everyNDays(int days) {
    return 'Cada $days días';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get noCareLogged => 'Aún no has registrado cuidados.';

  @override
  String get scannerHint => 'Apunta a una planta';

  @override
  String get analyzing => 'Analizando...';

  @override
  String get notIdentified => 'No identificada con certeza';

  @override
  String potsRemaining(int count) {
    return 'Macetas restantes: $count';
  }

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get markAllRead => 'Marcar todas como leídas';

  @override
  String get todayLabel => 'HOY';

  @override
  String get thatsAllForNow => 'Eso es todo por ahora';

  @override
  String get noNotifications => 'No tienes notificaciones';

  @override
  String get wateringPending => 'Riego pendiente';

  @override
  String get achievementUnlocked => '¡Logro desbloqueado!';

  @override
  String get newPlantAdded => 'Nueva planta agregada';

  @override
  String get seedbed => 'Semillero';

  @override
  String get redeemSeeds => 'Canjea tus semillas por recompensas';

  @override
  String get search => 'Buscar...';

  @override
  String get communityFavorites => 'Los favoritos de la comunidad';

  @override
  String get newBadge => 'Nuevo';

  @override
  String get yourImpactEquals => 'Tu impacto equivale a:';

  @override
  String treesEquivalent(int count) {
    return '$count Árboles';
  }

  @override
  String kilometersEquivalent(int count) {
    return '$count Kilómetros';
  }

  @override
  String levelAndTrophies(int level, int trophies) {
    return 'Nivel $level · $trophies trofeos';
  }

  @override
  String get noAchievementsYet => 'No has completado logros todavía.';

  @override
  String get allAchievementsDone => '¡Ya desbloqueaste todos los logros!';

  @override
  String get noAchievementsConfigured => 'Todavía no hay logros configurados.';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get reward => 'Recompensa';

  @override
  String get achievementUnlockedLabel => 'Logro desbloqueado';

  @override
  String get achievementLockedLabel => 'Logro bloqueado';

  @override
  String get activeMissions => 'Misiones Activas';

  @override
  String get plantCatalog => 'Catálogo de Plantas';

  @override
  String get seedStore => 'Tienda de Semillas';

  @override
  String get freePlanActive => 'Plan gratuito activo';

  @override
  String get user => 'Usuario';

  @override
  String get loading => 'Cargando...';

  @override
  String get genericError => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get catTropical => 'Tropical';

  @override
  String get catSucculent => 'Suculenta';

  @override
  String get catCactus => 'Cactus';

  @override
  String get catFern => 'Helecho';

  @override
  String get catFlowering => 'Con flores';

  @override
  String get catHerb => 'Aromática';

  @override
  String get catTree => 'Árbol';

  @override
  String get catOther => 'Planta';

  @override
  String get lightLow => 'Baja';

  @override
  String get lightMedium => 'Media';

  @override
  String get lightHigh => 'Alta';

  @override
  String get lightIndirect => 'Indirecta';

  @override
  String lightPrefix(String level) {
    return 'Luz $level';
  }

  @override
  String get difficultyVeryEasy => 'Muy fácil';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Media';

  @override
  String wateringEveryDays(int days) {
    return 'Riego c/${days}d';
  }

  @override
  String get humidityLow => 'Baja';

  @override
  String get humidityMedium => 'Media';

  @override
  String get humidityHigh => 'Alta';

  @override
  String impactCarTitle(String km) {
    return '$km km en coche';
  }

  @override
  String get impactCarSubtitle =>
      'Que no haría falta conducir para emitir ese CO₂.';

  @override
  String impactBulbTitle(String hours) {
    return '$hours h de bombilla LED';
  }

  @override
  String get impactBulbSubtitle => 'De consumo eléctrico equivalente.';

  @override
  String impactTreeTitle(String days) {
    return '$days días de un árbol';
  }

  @override
  String get impactTreeSubtitle =>
      'Lo que tarda un árbol adulto en absorber lo mismo.';

  @override
  String get impactApproxNote =>
      'Equivalencias aproximadas, calculadas a partir del CO₂ de tu jardín.';

  @override
  String get impactTooSmall =>
      'Tu jardín aún no acumula CO₂ suficiente para una equivalencia útil.';

  @override
  String accumulatedGrams(String grams) {
    return 'Acumulado: $grams g';
  }
}
