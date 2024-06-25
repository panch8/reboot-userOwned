import Pricipal "mo:base/Principal";
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Float "mo:base/Float";



shared ({ caller = creator }) actor class UserCanister() = this {
  let owner : Principal = creator;
  let nanoSecondsPerDay = 1_000_000_000 * 60 * 60 * 24; 
  var alive : Bool = true;
  var latestPing : Time.Time = Time.now();
  
  func _kill () : async () {
    if (Time.now() - latestPing > nanoSecondsPerDay)
        alive := false;
    };

  let daily = Timer.recurringTimer<system>(#nanoseconds(1_000_000_000 * 10), _kill);  

  public shared ({ caller }) func dailyPing() : async () {
    assert (caller == owner);
    latestPing := Time.now();
    alive := true;

  };

  public query func isAlive() : async Bool {
    return alive;
  };

  // public query func whoAmI() : async Principal {
  //   return owner;
  // };

  public query func getLatestPing() : async Text {
    //EPOC 1.1.1970

    let seconds : Time.Time = latestPing / 1_000_000_000; // convert to seconds
    let days = seconds / 86400;  //convert to days
    var remining_seconds = seconds % 86400; // get the remaining seconds
    let hours = remining_seconds / 3600 + 2 ; // convert to hours added 2from UTC to italy
    remining_seconds := remining_seconds % 3600; // get the remaining seconds 
    let minutes = remining_seconds / 60; // convert to minutes
    remining_seconds := remining_seconds % 60; // get the remaining seconds

    //days into date 
    //1 year is 365.25 days
    let floatYears: Float = Float.fromInt(days) / 365.25 + 1970;
    let years = Float.toInt(floatYears);
    var remaining_days: Float = Float.fromInt(days) % 365.25;
    let months: Float = remaining_days / 30.4375 + 1;
    remaining_days := remaining_days % 30.4375 + 2;
    let dateStr : Text = " Date : " # Int.toText(Float.toInt(remaining_days)) # " / " # Int.toText(Float.toInt(months)) # " / " # Int.toText(years) # " At " # Int.toText(hours) # ":" # Int.toText(minutes) # ":" # Int.toText(remining_seconds) # " UTC+2";
  
    Debug.print("Date: " # debug_show(dateStr));
    
    return dateStr;
  };
}
