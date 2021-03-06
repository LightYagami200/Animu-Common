import '../events/guild_event.dart';
import '../repos/animu_repo.dart';
import '../states/guild_state.dart';
import '../models/guild.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class GuildBloc extends Bloc<GuildEvent, GuildState> {
  final AnimuRepository animuRepository;

  GuildBloc({@required this.animuRepository}) : assert(animuRepository != null);

  @override
  GuildState get initialState => GuildEmpty();

  @override
  Stream<GuildState> mapEventToState(GuildEvent event) async* {
    if (event is FetchGuild) {
      yield GuildLoading();

      try {
        final Guild guild = await animuRepository.getGuild();

        yield GuildLoaded(guild: guild);
      } catch (e) {
        yield GuildError();
      }
    }
  }
}
