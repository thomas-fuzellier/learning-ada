--  Prints a framed banner for lesson 1, followed by the author's name
with Ada.Text_IO;

procedure Ex01_Banner is
begin
   Ada.Text_IO.Put_Line ("+----------------------------+");
   Ada.Text_IO.Put_Line ("|        LEARNING ADA        |");
   Ada.Text_IO.Put_Line ("|  Lesson 01: first program  |");
   Ada.Text_IO.Put_Line ("+----------------------------+");
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put ("Author: ");
   Ada.Text_IO.Put_Line ("Thomas Fuzellier");
end Ex01_Banner;
