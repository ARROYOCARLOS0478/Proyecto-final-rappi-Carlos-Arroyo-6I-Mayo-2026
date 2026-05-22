class Traducciones {
  static String traducirError(dynamic error) {
    String message = error.toString().toLowerCase();
    
    // --- Autenticación (Firebase Auth) ---
    if (message.contains('invalid-credential') || 
        message.contains('supplied auth credential is incorrect')) {
      return "El correo o la contraseña son incorrectos.";
    }
    if (message.contains('user-not-found') || 
        message.contains('no user record')) {
      return "No existe ninguna cuenta con este correo.";
    }
    if (message.contains('wrong-password')) {
      return "La contraseña no es correcta.";
    }
    if (message.contains('invalid-email') || 
        message.contains('badly formatted')) {
      return "El correo electrónico no tiene un formato válido.";
    }
    if (message.contains('email-already-in-use')) {
      return "Este correo ya está registrado con otra cuenta.";
    }
    if (message.contains('weak-password') || 
        message.contains('6 characters')) {
      return "La contraseña debe tener al menos 6 caracteres.";
    }
    if (message.contains('too-many-requests')) {
      return "Demasiados intentos fallidos. Inténtalo más tarde.";
    }
    if (message.contains('user-disabled')) {
      return "Esta cuenta ha sido deshabilitada.";
    }

    // --- Base de Datos (Firestore) ---
    if (message.contains('permission-denied')) {
      return "No tienes permiso para realizar esta acción.";
    }
    if (message.contains('unavailable')) {
      return "El servicio no está disponible. Revisa tu conexión.";
    }
    if (message.contains('not-found')) {
      return "El registro no fue encontrado.";
    }
    if (message.contains('already-exists')) {
      return "Este registro ya existe.";
    }

    // --- Otros / Genéricos ---
    if (message.contains('network-request-failed') || 
        message.contains('failed host lookup')) {
      return "Error de conexión. Revisa tu internet.";
    }
    if (message.contains('authenticate is not supported on the web')) {
      return "El inicio con Google no está listo en web. Usa tu correo.";
    }
    
    return "Ocurrió un error inesperado. Por favor, intenta de nuevo.";
  }
}
