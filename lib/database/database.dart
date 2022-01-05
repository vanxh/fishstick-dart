import "package:mongo_dart/mongo_dart.dart";
import "../client/client.dart";
import "database_user.dart";

class Database {
  /// The main bot client.
  late final Client _client;

  /// The database connection.
  late final Db db;

  /// users collections
  late DbCollection users;

  /// discord guilds collections
  late DbCollection guilds;

  /// stw leaderboards collections
  late DbCollection leaderboards;

  /// The database object
  Database(this._client) {
    db = Db(_client.config.mongoUri);
  }

  /// connect to the database
  Future<void> connect() async {
    await db.open();

    users = db.collection("users");
    guilds = db.collection("guilds");
    leaderboards = db.collection("leaderboards");
  }

  Future<DatabaseUser> getUser(String id) async {
    var user = await users.findOne(where.eq("id", id));
    user ??= await users.insert({
      "id": id,
      "name": "",
      "selectedAccount": "",
      "linkedAccounts": [],
      "premium": {
        "until": DateTime.now(),
        "tier": 0,
        "grantedBy": "",
      },
      "bonusAccLimit": 0,
      "autoSubscriptions": {
        "dailyRewards": false,
        "freeLlamas": false,
        "collectResearchPoints": false,
        "research": "none",
      },
      "dmNotifications": false,
      "color": "#09b7d6",
      "privacy": 0,
      "blacklisted": {
        "on": DateTime.now(),
        "value": false,
        "reason": "",
      },
      "sessions": {},
    });

    return DatabaseUser.fromJson(this, user);
  }
}
