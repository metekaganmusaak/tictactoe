enum ErrorsEnum {
  databaseError,
  authError;
}

class AppErrors {
  final ErrorsEnum error;

  AppErrors(this.error);

  @override
  String toString() {
    switch (error) {
      case ErrorsEnum.databaseError:
        return 'Database error';
      case ErrorsEnum.authError:
        return 'Auth error';
    }
  }
}
