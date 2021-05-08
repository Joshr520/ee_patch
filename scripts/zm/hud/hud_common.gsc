#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\zm\_zm_utility;
#insert scripts\shared\shared.gsh;
#using scripts\shared\ai\zombie_utility;

#insert scripts\zm\hud\hud_common.gsh;

#namespace hud_common;

function main(type,value,flag_display_func,flag_destroy_func,lifetime_func,str_notify,fadeintime,fadeouttime,sizex,sizey)
{
	self.alpha = 0;
	switch (type)
	{
		case TEXT_ID:
			self SetText(value);
			break;
		case ICON_ID:
			self SetShader(value,sizex,sizey);
			break;
	}
	self [[ flag_display_func ]]();
	self FadeOverTime(fadeintime);
	self.alpha = 1;
	if(lifetime_func != "") self thread [[ lifetime_func ]]();
	self [[ flag_destroy_func ]]();
	if(str_notify != "") self notify(str_notify);
	wait .5;
	self FadeOverTime(fadeouttime);
	self.alpha = 0;
	wait(fadeouttime);
	self Destroy();
}
function common_reset(alignx,aligny,horzalign,vertalign,foreground,hideinmenu,x,y)
{
	self.alignX = alignx;
	self.alignY = aligny;
	self.horzAlign = horzalign;
	self.vertAlign = vertalign;
	self.foreground = foreground;
	self.hidewheninmenu = hideinmenu;
	self.x = x;
	self.y = y;
	self.alpha = 0;
}
function reset_hud(type,alignx,aligny,horzalign,vertalign,foreground,hideinmenu,x,y,font,fontscale,color,text="")
{
	self common_reset(alignx,aligny,horzalign,vertalign,foreground,hideinmenu,x,y);
	if (type == TEXT_ID) self text_reset(font,fontscale,color,text);
}
function text_reset(font,fontscale,color,text="")
{
	self.font = font;
	self.fontScale = fontscale;
	self.color = color;
	self SetText(text);
}