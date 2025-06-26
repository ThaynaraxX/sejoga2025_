# Sejoga 2025 

Aplicativo de navegação indoor acessível para pessoas com deficiência visual, desenvolvido com Flutter, é uma nova versão de um projeto anterior, recriado para fins de organização e atualização.

---

### Tecnologias
- Flutter
- Bluetooth / Wi-Fi (localização)
- Agentic Application (backend em AWS)
- Text-to-Speech (leitura por voz)

---

### Funcionalidades
- Detecta localização por beacon ou Wi-Fi
- Gera instruções de navegação via backend inteligente
- Leitura em voz das instruções
- Interface acessível e simplificada

---
### Configuração da chave da IA

Para que o app gere instruções utilizando o Gemini, informe a chave de API do Google Generative AI ao executar o aplicativo:

```bash
flutter run --dart-define=AI_API_KEY=SEU_TOKEN
```

Substitua `SEU_TOKEN` pela sua chave. Se a chave não for fornecida, o aplicativo exibirá uma mensagem informando a ausência da configuração.

---

🔒 Projeto acadêmico - 2025

---

### Licença

Este projeto está licenciado sob os termos da [Licença MIT](LICENSE).


