shader_type canvas_item;

uniform vec2 cameraPosition = vec2(0.);
uniform sampler2D starsFront;
uniform sampler2D starsBack;
uniform sampler2D nebulaFront;
uniform sampler2D nebulaBack;

vec3 getBackground(vec2 uv, float TIME, vec2 offset){
	vec3 black = vec3(0.);
	//background 
	vec2 wiggleF = vec2 ( .0005*cos(TIME*20.0+500. * uv.y), .005*cos(TIME*10.0-1000. * uv.y));
	vec2 wiggleB = vec2 ( .0005*cos(TIME*20.0+100. * uv.y), .005*cos(TIME*10.0-100. * uv.y));
	
	vec3 sf = textureLod(starsFront, offset + vec2(uv.x * 1.2, uv.y *1.8) + wiggleB, 0.).rgb;
	vec3 sb = textureLod(starsBack, offset + vec2(uv.x * 1.5, uv.y *2.) + wiggleB, 0.).rgb*.7;
	
	vec3 nf = textureLod(nebulaFront, offset*0.42 + uv*0.5 + wiggleB, 0.).rgb * 0.2;
	vec3 nb = textureLod(nebulaBack, offset+ uv + wiggleB*0.1, 0.).rgb * 0.15;
	return black+nb+sb+nf+sf;
//	return black;
}

void fragment(){
	float pixely = SCREEN_PIXEL_SIZE.y;
	float pixelx = SCREEN_PIXEL_SIZE.x;
	float mirrorHeight = pixely * 150. * (sin( (UV.y*1.6) * 2.) );
	vec3 screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	vec2 offset = cameraPosition / (1.0 / SCREEN_PIXEL_SIZE);
	
	vec3 background = getBackground(UV,TIME,offset);
	vec3 ripples = vec3(0.);
	
	//get rid of pink color lines for artificial reflection height
	if (screen == vec3(1,0,1)){
		screen = vec3(0);
	}
	
	//ripples
	for ( float i = 0.; i < mirrorHeight; i += pixely){
		
		//get of position above to check for color to determine if ripple is needed
		vec2 checkPos = SCREEN_UV + vec2(0., i);
		vec3 checkPoint = textureLod(SCREEN_TEXTURE, checkPos, 0.).rgb;

		//check if the reflection point is found
		if ( length( checkPoint ) > .2 ) {
			if ( length(textureLod(SCREEN_TEXTURE, checkPos + vec2(0., i/2.), 0.).rgb) < .1 ) continue;
			if ( length(textureLod(SCREEN_TEXTURE, checkPos + vec2(0., i/4.), 0.).rgb) < .1 ) continue;
			if ( length(textureLod(SCREEN_TEXTURE, checkPos + vec2(0., i/5.), 0.).rgb) < .1 ) continue;
			if ( length(textureLod(SCREEN_TEXTURE, checkPos + vec2(0., i/6.), 0.).rgb) < .1 ) continue;
			if ( length(textureLod(SCREEN_TEXTURE, checkPos + vec2(0., i/8.), 0.).rgb) < .1 ) continue;
			if ( length(textureLod(SCREEN_TEXTURE, checkPos + vec2(0., i/10.), 0.).rgb) < .1 ) continue;
			if ( length(textureLod(SCREEN_TEXTURE, checkPos + vec2(0., i/20.), 0.).rgb) < .1 ) continue;
			//get mirror point based on where guide line was found
			vec2 mirPos = checkPos + vec2(0., i);
			
			//calculate fade for lod and fade to black
			float fade = 1.*(1. - i / mirrorHeight);
			vec2 rippleWiggle = vec2(.0005*cos(TIME*20.0+500. * UV.y), .005*cos(TIME*10.0-1000. * UV.y) );
			
			//set ripple refection color
			vec3 mirColor = textureLod(SCREEN_TEXTURE, mirPos + rippleWiggle, 1.-fade).rgb;
			
			//get rid of pink guide line in reflection
			if( length(mirColor) < .2){
				continue;
			} else {
				//apply fade to black
				//if (mirColor.r*0.2 > mirColor.g && mirColor.b*0.2 > mirColor.g ) {mirColor = vec3(0)}
				mirColor *= fade;
				mirColor*= 0.5;
				ripples = mirColor;
				break;
			}
		} 
	}
	
	
	//check if the pixel on screen is foreground by seeing the strength of it's color, otherwise blend them together. 
	//allows transparency for foreground objects over water
	if (length(screen) < .2 ) {
		COLOR = vec4(background+screen+ripples,1);
	} else {
		COLOR = vec4(screen, 1);
	}
	
}