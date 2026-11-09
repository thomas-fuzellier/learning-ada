--  Print a mission with a briefing for lesson 02
with Ada.Text_IO; use Ada.Text_IO;

procedure Ex02_mission_brief is
begin
   --  En-tête de la mission
   Put_Line ("=============================");
   Put_Line ("       MISSION BRIEFING      ");
   Put_Line ("=============================");
   New_Line;
   --  Briefing de la mission
   Put ("Operation:");
   Put (" ");
   Put_Line ("""Silent Falcon""");
   Put_Line ("Status:    READY");
   Put_Line ("Priority:  HIGH");
   New_Line;
   Put_Line ("Orders:");
   Put_Line ("  1. Compile without warnings.");
   Put_Line ("  2. Review every line.");
   Put_Line ("  3. Report to command.");
   New_Line;
   --  Conclusion
   Put_Line ("-- End of briefing --");
end Ex02_mission_brief;
