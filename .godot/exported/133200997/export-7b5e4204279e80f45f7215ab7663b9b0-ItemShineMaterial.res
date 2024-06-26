RSRC                    ShaderMaterial            ��������                                            
      resource_local_to_scene    resource_name    code    script    shader    shader_parameter/intensity    shader_parameter/wiggle_time    shader_parameter/shine_color    shader_parameter/shine_speed    shader_parameter/shine_size           local://Shader_qxj1p �         local://ShaderMaterial_8ceds �         Shader          �  shader_type canvas_item;

uniform float intensity = 3.0;
uniform float wiggle_time = 1.5;

uniform vec4 shine_color;
uniform float shine_speed;
uniform float shine_size;

void vertex() {
	VERTEX.y += sin(TIME * wiggle_time + VERTEX.x * 0.05) * intensity;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	float shine = step(1.0 - shine_size * 0.5, 0.5 + 0.5 * sin(UV.x - UV.y + TIME * shine_speed));
	COLOR.rgb = mix(COLOR.rgb, shine_color.rgb, shine * shine_color.a);
}

/*
---DOCUMENTACIÓN---

	-variaveis do wobble
	-variaveis do brilho
	
	void vertex:
		
		posição y do vertice += função de seno(
			tempo * mod_de_tempo + posição_X *
			 0.05
		) * intensidade_do_wobble;
		
	
	void fragment:
		brilho = interpolar(
			LIMITE: 1 - tamanho_do_brilho * 0.5,
			VALOR: 0.5 + função de seno(
				posição_X - posição_Y + tempo * velocidade_dp_brilho
			) * 0.5;
		)
		
		cor = interpolação_linear(
			VALOR_A: cor,
			VALOR_B: cor_do_brilho,
			TEMPO: transparencia_do_brilho
		);
		
	

*/          ShaderMaterial                         @@        �?   2     �?  �?  �?  �?        �@	   )   {�G�z�?      RSRC