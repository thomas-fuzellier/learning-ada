--  Exercise number 1 of my Ada's course
--  Subject : creation of a banner in Ada via the basic function
with Ada.Text_IO;

procedure ex01_banner is
begin
   Ada.Text_IO.Put_Line ("+----------------------------+");
   Ada.Text_IO.Put_Line ("|        LEARNING ADA        |");
   Ada.Text_IO.Put_Line ("|  Lesson 01: first program  |");
   Ada.Text_IO.Put_Line ("+----------------------------+");
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put ("Author: ");
   Ada.Text_IO.Put_Line ("Thomas Fuzellier");
end ex01_banner;
