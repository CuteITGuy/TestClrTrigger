using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using Microsoft.SqlServer.Server;
using SocketClient;

public partial class Triggers
{
    private const string FILE = @"D:\a.txt";
    #region Methods
    [SqlTrigger(Name = "SqlTrigger", Target = "People", Event = "FOR INSERT")]
    public static void SqlTrigger()
    {
        var context = SqlContext.TriggerContext;
        if (context.TriggerAction != TriggerAction.Insert) return;

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

                    while (reader.Read())
                    {
                        pipe.Send(reader[0].ToString());
                        /*File.WriteAllText(FILE, reader[0].ToString());
                        Process.Start("explorer.exe", "/select, " + FILE);*/
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