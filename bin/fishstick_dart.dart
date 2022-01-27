import "package:fishstick_dart/fishstick_dart.dart";

void main() async {
  /// register the commands
  client.commands.addCommand(pingCommand);
  client.commands.addCommand(inviteCommand);
  client.commands.addCommand(infoCommand);
  client.commands.addCommand(helpCommand);
  client.commands.addCommand(autopostCommand);
  client.commands.addCommand(colorCommand);
  client.commands.addCommand(settingsCommand);
  client.commands.addCommand(premiumCommand);
  client.commands.addCommand(partnerCommand);
  client.commands.addCommand(blacklistCommand);
  client.commands.addCommand(loginCommand);
  client.commands.addCommand(logoutCommand);
  client.commands.addCommand(accountCommand);
  client.commands.addCommand(gameLaunchCommand);
  client.commands.addCommand(vbucksCommand);
  client.commands.addCommand(affiliateCommand);
  client.commands.addCommand(mfaCommand);
  client.commands.addCommand(afkCommand);
  client.commands.addCommand(overviewCommand);
  client.commands.addCommand(resourcesSTWCommand);
  client.commands.addCommand(lockerCommand);
  client.commands.addCommand(skipTutorialCommand);
  client.commands.addCommand(homebaseNameCommand);
  client.commands.addCommand(stwUpgradeCommand);
  client.commands.addCommand(mskCommand);
  client.commands.addCommand(pendingDifficultyRewardsCommand);
  client.commands.addCommand(survivorSquadPresetCommand);

  /// start the client
  await client.start();
}
