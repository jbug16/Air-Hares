// Text - credits

text = "In loving memory of Mark Leo Mendoza."

text += "\n\n\n\n\n\n\n----------------- DEVELOPMENT -----------------";
text += "\n~Written and Designed by~";
text += "\nTim Bungeroth";
text += "\n\n~Art and Character Creation by~";
text += "\nMark Leo Mendoza";
text += "\n\n~Programming and Game Design~";
text += "\nRidho Heramasa";
text += "\n\n~Programming and UI Design~";
text += "\nGameGlis Studio"
text += "\nEugen Stimac"
text += "\nIvana Tus";
text += "\n\n~Programming and Debugging~";
text += "\nJenna Curls";
text += "\n\n~Music by~";
text += "\nOmar Chakor";
text += "\n\n~Executive Produced by~";
text += "\nMegan Bungeroth";

text += "\n\n\n\n\n\n\n----------------- PUBLISHING -----------------";
text += "\nPublished by indie.io team";
text += "\n\n~Founders~";
text += "\nDonovan Duncan";
text += "\nBen Robinson";
text += "\n\n~Director of Business Development~";
text += "\nBenjamin Tarsa";
text += "\n\n~Financial Controller~";
text += "\nAmanda Hoppe";
text += "\n\n~Junior Accountant/HR assistant~";
text += "\nKristi Harms";
text += "\n\n~HR Manager~";
text += "\nKiana Cassell";
text += "\n\n~Bookkeeper~";
text += "\nAshlynn Simmons";
text += "\n\n~wiki.gg Team Lead~";
text += "\nRiver";

text += "\n\n~Creative Production Manager~";
text += "\nRogelio Dominguez";
text += "\n\n~Senior Motion Graphics Designer~";
text += "\nIanna Dria Besa";
text += "\n\n~Graphic Designers~";
text += "\nVeronica Irizarry";
text += "\nAngela Maldonado";
text += "\n\n~Video Editor~";
text += "\nBruno Bonini";

text += "\n\n~Copywriter~";
text += "\nMinerva Filipiak";

text += "\n\n~Director of Engineering~";
text += "\nEvan Bryant";
text += "\n\n~Lead Software Engineer~";
text += "\nJohn Popilek";
text += "\n\n~Senior Software Engineer~";
text += "\nBen Jenkins";
text += "\n\n~Release Specialist~";
text += "\nEthan Irish";
text += "\n\n~IT Manager~";
text += "\nJonathan Johnson";
text += "\n\n~Director of Developer Operations~";
text += "\nJohn C. Boone II";

text += "\n\n~Associate Game Designer~";
text += "\nVitor Hugo Moura";
text += "\n\n~Game Designer~";
text += "\nKerri King";

text += "\n\n~QA Manager~";
text += "\nVitoria Ama";
text += "\n\n~QA Analysts~";
text += "\nAlexandre Carchano";
text += "\nCaroline Frattini";
text += "\nGabriel Bergami";

text += "\n\n~Director of Operations~";
text += "\nJordan Kahn";
text += "\n\n~Operations Manager~";
text += "\nCiera Adair";

text += "\n\n~Director of Marketing~";
text += "\nJess Mitchell";
text += "\n\n~Marketing Managers~";
text += "\nKatie VanClieaf";
text += "\nBen Smith";
text += "\n\n~Digital Marketing Manager~";
text += "\nEleni Sagredos";
text += "\n\n~Storefronts Manager~";
text += "\nAlyssa DiCaterino";
text += "\n\n~Community Manager~";
text += "\nAnnette Bowen";


draw_set_font(fnt_Federo24);
txt_height = string_height(text);

// Text - poem
y = 0.12*room_height;
text0[0] = "What does mother nature truly deem?";
array_push(text0, "\nMust we all accept our given fate,");
array_push(text0, "\nor can we build, in faith, a brand new world");
array_push(text0, "\nwherein such cataclysms are embraced?");
array_push(text0, "\nFor in this life of mystery and science");
array_push(text0, "\nthe only law of nature is defiance.");
text0_lines = 0;		// how many lines were loaded
text0_line_alpha = 0;	// current line alpha
text0_spd = 2.8*GAMESPD;	// how fast to go to next line
TweenStart("text0_line_alpha", 0, 1, text0_spd);
alarm[5] = text0_spd;

// General
phase = 0;	// 0 - image | 1 - scroll text | 2 - logo
music = noone;
alarm[4] = 0.5*GAMESPD;	// input disable
from_options = false;
// Fade in
//TweenStart("image_alpha", 0, 1, 2*GAMESPD);
//alarm[0] = 12*GAMESPD;