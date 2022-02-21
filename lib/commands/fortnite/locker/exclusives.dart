import "dart:convert";

import "package:nyxx/nyxx.dart";
import "package:nyxx_commands/nyxx_commands.dart";
import "package:nyxx_interactions/nyxx_interactions.dart";

import "package:fortnite/fortnite.dart";

import "../../../fishstick_dart.dart";

import "../../../database/database_user.dart";

import "../../../extensions/context_extensions.dart";

import "../../../structures/privacy.dart";

import "../../../resources/emojis.dart";

import "../../../utils/utils.dart";

final ChatCommand lockerExclusivesImageCommand = ChatCommand(
  "exclusives",
  "View your locker exclusive items in an image format.",
  Id(
    "locker_exclusives_command",
    (
      IContext ctx, [
      @Description("User to view locker for") IUser? user,
    ]) async {
      if (client.cachedCosmetics.isEmpty) {
        throw Exception(
            "Cosmetics are not loaded yet, please try again in a while.");
      }

      DatabaseUser dbUser = await ctx.dbUser;
      dbUser.fnClientSetup();

      if (user != null) {
        dbUser = await client.database.getUser(user.id.toString());
        if (dbUser.linkedAccounts.isEmpty) {
          throw Exception("This user has no linked accounts.");
        }
        if (dbUser.privacyEnum == Privacy.private) {
          throw Exception("This user has set their privacy to private.");
        }
      }
      dbUser.fnClientSetup();

      await dbUser.fnClient.athena.init();

      IMessage msg = await ctx.respond(
        ComponentMessageBuilder()
          ..content = "Rendering locker image for exclusives ${loading.emoji}"
          ..componentRows = [],
      );

      List<AthenaCosmetic> cosmetics = filterAndSortCosmetics(
        dbUser: dbUser,
        type: "exclusives",
      );

      if (cosmetics.isEmpty) {
        return await msg.edit(
          MessageBuilder.content(
            "${(user ?? ctx.user).username} don't have any exclusives in their locker.",
          ),
        );
      }

      List<List<AthenaCosmetic>> chunks = await cosmetics.chunk(350).toList();

      List<int> img;
      for (var i = 0; i < chunks.length; i++) {
        int startTime = DateTime.now().millisecondsSinceEpoch;
        img = base64Decode(
          await client.imageUtils.drawLocker(
            cosmetics: chunks[i],
            epicname: "${(user ?? ctx.user).tag} [${i + 1}/${chunks.length}]",
          ),
        );

        await ctx.respond(
          MessageBuilder.embed(
            EmbedBuilder()
              ..author = (EmbedAuthorBuilder()
                ..name = (user ?? ctx.user).username
                ..iconUrl = (user ?? ctx.user).avatarURL(format: "png"))
              ..description =
                  "Rendered locker image in ${((DateTime.now().millisecondsSinceEpoch - startTime) / 1000).toStringAsFixed(2)}s"
              ..color = DiscordColor.fromHexString(dbUser.color)
              ..title =
                  "${dbUser.activeAccount.displayName}'s Exclusives Locker"
              ..timestamp = DateTime.now()
              ..footer = (EmbedFooterBuilder()..text = client.footerText)
              ..imageUrl = "attachment://locker-$i.png",
          )
            ..addAttachment(
              AttachmentBuilder.bytes(
                img,
                "locker-$i.png",
              ),
            )
            ..content = ctx.user.mention,
        );
      }

      await msg.delete();
    },
  ),
  checks: [premiumCheck],
);
