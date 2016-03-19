using System.Data.SqlClient;
using Microsoft.SqlServer.Server;
using SocketClient;

public class Triggers
{
    #region Methods
    [SqlTrigger(Name = "SqlTrigger", Target = "People", Event = "FOR INSERT")]
    public static void SqlTrigger()
    {
        var context = SqlContext.TriggerContext;
        if (context == null || context.TriggerAction != TriggerAction.Insert) return;

        using (
            var con =
                new SqlConnection(" context connection=true"))
        {
            con.Open();
            using (var cmd = new SqlCommand("SELECT Name FROM INSERTED", con))
            {
                using (var reader = cmd.ExecuteReader())
                {
                    var pipe = SqlContext.Pipe;
                    if (pipe == null) return;

                    while (reader.Read())
                    {
                        pipe.Send(reader[0].ToString());
                        var sender = new SocketSender();
                        sender.MessageReceived += (o, message) => pipe.Send(message);
                        sender.Send(reader[0].ToString());
                    }
                }
            }
        }
    }
    #endregion
}