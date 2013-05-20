ignored_icons="Sprite Sound Background Path Script Font Timeline Object Room Model3D Definitions Overworld Extension Folder OpenFolder Folder2 OpenFolder2 Bug_Basic"
icons="Sprite_GMB Sound_GMB Background_GMB Path_GMB Script_GMB Font_GMB Timeline_GMB Object_GMB Room_GMB Model_GMB Definitions_GMB Overworld_GMB Extension_GMB Speaker Sprite_CC Sound_CC Photo Path_CC Script_CC Font2 Timeline_CC Extension_CC New NewPlus Save SaveAll SaveAs Close Settings SimpleArrowLeft SimpleArrowRight SimpleX InfoButton Help SettingsBox SettingsWindow CascadeWindows Problem Book Wrench Folder_Orange OpenFolder_Orange NewFolder_Orange DeleteFolder_Orange Folder_Brown OpenFolder_Brown NewFolder_Brown DeleteFolder_Brown Folder2_Brown OpenFolder2_Brown NewFolder2_Brown NewFolder_Brown DeleteFolder2_Brown Folder2_Orange OpenFolder2_Orange NewFolder2_Orange NewFolder_Brown DeleteFolder2_Orange ArrowRun ArrowDebug ArrowDesign KillButton Playback_Play Playback_Stop CheckMark RedX BuildBinary Bug_Green_Spots Bug_Red_Spots Bug_Blue_Spots Bug_Green Bug_Red Bug_Blue Broom Undo Redo Bold Italics Underline Goto Highlighter MagnifyingGlass ZoomIn ZoomOut Printer Cut Copy Clipboard SearchPaper Palette Search Step Wand Mouse KeyUp KeyDown Keyboard LightningBolt Bomb LightBulb Paintbrush Collision Collision2 AlarmClock FilmStrip Bare_Action_Folder ActionFolder_Step ActionFolder_Wand ActionFolder_Mouse ActionFolder_KeyUp ActionFolder_KeyDown ActionFolder_Keyboard ActionFolder_LightningBolt ActionFolder_Bomb ActionFolder_Lightbulb ActionFolder_Paintbrush ActionFolder_Collision ActionFolder_Collision2 ActionFolder_AlarmClock ActionFolder_Filmstrip ActionFolder_Paper"
#mkdir individual
mkdir raster
for icon in $icons
do
  # Calculate the screen coordinates of the icon, since InkScape is FAR, FAR too fucking stupid
  # to do this for you in any sensible way. Don't bother exporting the images with the --export-area-snap
  # option; that can't align them to a grid, only to whole pixels. And it can't round, only floor/ceil.
  # And then you have to use that piece of shit, ImageMagick, to make them the correct size. FUCK ImageMagick.
  # For that matter, FUCK INKSCAPE! Get your shit straight! It's cool that you thought it would help novices
  # cope if (0,0) was the fucking top-left corner, even though for your most advanced users, that's completely
  # fucking counter-intuitive. I can respect this decision. My request is, BE FUCKING CONSISTENT! I query for
  # coordinates, I get the logical coordinates, from the top left. I ask you to render, and you want your
  # fucking bullshit coordinates from the bottom-left. WHAT THE FUCK? Well, I'm over it, because I can just
  # query for the document height and subtract it, right? WRONG! YOU FUCKS DON'T SUPPORT THAT, EITHER! You just
  # give me some bullshit decimal calculation of how much drawing space I'm using. You left me LITERALLY no way
  # of doing this with your program. I had to hard-code the damn document height because you offered NO means of
  # obtaining it any other way. Thanks. Your program is amazingly intuitive, as a GUI. Too bad everything about
  # the code, spec, and CLI are totally fucking disgustingly back-asswards ugly.
  
  x=`inkscape icons.svg --query-id="Icon_$icon" --query-x`; x=`echo "scale=0;($x+9)/18*18" | bc`;
  y=`inkscape icons.svg --query-id="Icon_$icon" --query-y`; y=`echo "scale=0;($y+9)/18*18" | bc`;
  y=$((800-y-18))
  x2=$((x+18))
  y2=$((y+18))
  inkscape icons.svg --export-id=Icon_$icon --export-area=$x:$y:$x2:$y2 --export-id-only --export-png=raster/Icon_$icon.png
  
  # Doesn't work because fuck InkScape.
  #inkscape icons.svg --export-id=Icon_$icon --export-area-snap --export-id-only --export-plain-svg=individual/Icon_$icon.svg
done
