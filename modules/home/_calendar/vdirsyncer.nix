# TODO: configure
{
  accounts.calendar = {
    basePath = "Calendar";

    accounts.Google = {
      primary = true;

      remote = {
        type = "google_calendar";
      };
    };
  };
}
