# Notes

## Union and Morgan Movement

Union movement is not directly simulated in the original game.
The configuration data is provided in `settings.properties`.
Morgan's speed (`Speed` component) starts at `RELSPEED_START`,
which is zero. It can go up to `RELSPEED_MAX` and down to
`RELSPEED_MIN`, which are 5 and -5. (I think these are sometimes
symbolically referenced in the source code and sometimes hardcoded
as 5.) It seems that whenever Morgan's speed gets down to 
`CAP_THRESHOLD` (default value: -3), he is captured by Shackleford,
as indicated by the corresponding comment in `settings.properties`.

Morgan's speed also determines his animation and audio.
This is implemented in `SpeedSystem.java`. 

- speed < -2: quarter speed sound and animation
- -2 <= speed < 1: half speed sound and animation
- 1 <= speed < 3: 3/4 speed sound and animation
- 3 < speed: full speed sound and animation

Note that there does seem to be a conflict above: if speed is less than -2,
then Morgan should have been caught, because `CAP_THRESHOLD`'s value
of -3 has been met. I suspect that quarter speed was never actually
seen in practice, unless this test was done after one movement was
complete rather than after completing a raid.

The individual sprite animation coordinates are in `SpeedSystem.java`
as well:

```java
	    morgImgLocation = "images/sprite_sheet_quarter_speed.png";
	    morgImg = new Image(morgImgLocation);
	    morgSheet = new SpriteSheet(morgImg, 150, 90);
	    morg_speed_quarter = new Animation(morgSheet, 135);

	    morgImgLocation = "images/sprite_sheet_half_speed.png";
	    morgImg = new Image(morgImgLocation);
	    morgSheet = new SpriteSheet(morgImg, 150, 90);
	    morg_speed_half = new Animation(morgSheet, 120);

	    morgImgLocation = "images/sprite_sheet_three_quarter_speed.png";
	    morgImg = new Image(morgImgLocation);
	    morgSheet = new SpriteSheet(morgImg, 150, 90);
	    morg_speed_three_quarter = new Animation(morgSheet, 105);

	    morgImgLocation = "images/sprite_sheet_full_speed.png";
	    morgImg = new Image(morgImgLocation);
	    morgSheet = new SpriteSheet(morgImg, 150, 90);
	    morg_speed_full = new Animation(morgSheet, 90);
```

`Sounds.java` contains the definition of the various audio effects, including
the various horse sounds.

```java
    /** The default "click" sound for button-like UI elements */
    CLICK("sounds/click.wav"),
    /** A click sound that can be used when clicking has no effect. */
    CLICK_NOEFFECT("sounds/click_fail_2.wav"), //
    RAIDING("sounds/raiding_sfx.ogg"), //
    LONG_RAIDING("sounds/long_raiding_sfx.ogg"), //
    SIGNATURE("sounds/signature.ogg"), //
    HORSE_QUARTER(
	    "sounds/horse_speed/speed_quarter_network_soundeffects_disk_42_track_25.ogg"), //
    HORSE_HALF(
	    "sounds/horse_speed/speed_half_network_soundeffects_disk_42_track_27.ogg"), //
    HORSE_THREE_QUARTER(
	    "sounds/horse_speed/speed_three_quarter_network_soundeffects_disk_42_track_30.ogg"), //
    HORSE_FULL(
	    "sounds/horse_speed/speed_full_network_soundeffects_disk_42_track_35.ogg"), //
    CAMPFIRE("sounds/camping/campfire_network_soundeffects_disk_7_track_28.ogg"), //
    CRICKETS(
	    "sounds/camping/crickets_maxefx_sound_effects_library_disk_1_track_36.ogg"), //
    OWL("sounds/camping/owl_hooting_network_soundeffects_disk_44_track_50.ogg"), //
    SPEEDWARNING("sounds/speedwarning.ogg");
```