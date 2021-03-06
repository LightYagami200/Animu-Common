import '../events/level_settings_event.dart';
import '../repos/animu_repo.dart';
import '../states/level_settings_state.dart';
import '../models/role.dart';
import '../models/settings.dart';
import '../models/text_channel.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class LevelSettingsBloc extends Bloc<LevelSettingsEvent, LevelSettingsState> {
  final AnimuRepository animuRepository;

  LevelSettingsBloc({@required this.animuRepository})
      : assert(animuRepository != null);

  @override
  LevelSettingsState get initialState => LevelSettingsEmpty();

  @override
  Stream<LevelSettingsState> mapEventToState(
    LevelSettingsEvent event,
  ) async* {
    if (event is FetchLevelSettings) {
      yield LevelSettingsLoading();

      try {
        final List<dynamic> levelSettings =
            await animuRepository.getLevelSettings();
        final Settings settings = levelSettings[0];
        final List<Role> roles = levelSettings[1];
        final List<TextChannel> channels = levelSettings[2];
        yield LevelSettingsLoaded(
            settings: settings, channels: channels, roles: roles);
      } catch (e) {
        LevelSettingsError();
      }
    }

    if (event is UpdateLevelSettings) {
      try {
        final List<dynamic> levelSettings = await animuRepository
            .updateLevelSettings(key: event.key, value: event.value);
        final Settings settings = levelSettings[0];
        final List<Role> roles = levelSettings[1];
        final List<TextChannel> channels = levelSettings[2];
        yield LevelSettingsLoaded(
            settings: settings, channels: channels, roles: roles);
      } catch (e) {
        LevelSettingsError();
      }
    }
  }
}
