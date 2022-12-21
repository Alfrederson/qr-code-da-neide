# QR Code da Neide

Um leitor de QR Code com algumas funcionalidades:

- Gerar placa de PIX.
- Guardar os dados escritos.
- Copiar o código pra área de transferência.
- Trocar de telinhas mostrando um anúncio às vezes.
- Mostrar anúncio em baixo da tela.

# Como rodar?

Versão ao vivo e a cores:

https://play.google.com/store/apps/details?id=com.zandorr.qr_reader

É só instalar no seu Android.

## Ou se você não quiser me dar os centavinhos dos anúncios:

- Clone este repositório.

- Você pode usar a sua conta do AdMob ou usar os valores de teste que você consegue encontrar na documentação do AdMob (ou mobile ads? ).

- Primeiro você precisa criar um arquivo .env na raiz pra poder usar os anúncios.

Nesse .env, você coloca os seguinte valores:
```

ADMOB_APPLICATION_ID = ca-app-pub-0000000000000000~0000000000
ADMOB_AD_UNIT_ID = ca-app-pub-0000000000000000/0000000000
TEST_DEVICE_IDS = "8e27af98-4da7-4938-8dc1-3f3f54d10451 dcc8d09c-a17d-47b1-8ea0-d4e315db1e18"
```

**ADMOB_APPLICATION_ID** é o ID do app no admob.

 **ADMOB_AD_UNIT_ID** é o ID do anúncio (eu só usei um, que fica lá no component/banner_anuncio).
 
 **TEST_DEVICE_IDS** são os ids dos seus dispositivos de teste separados por espaço. Pra mim eles são o emulador e o meu telefone.

Se você não quiser anúncios, manualmente remova tudo do código.

Depois é só dar ```flutter pub get``` e rodar.

## O que seria interessante fazer depois disso?

- Deixar a pessoa criar uma lista de "produtos" pra poder fazer uma plaquinha de pagamento e um recibinho pra compartilhar pelo zipzop.

- Deixar a pessoa salvar vários QR codes diferentes pra reutilizar.

- Criar alguma flag pra poder compilar automaticamente uma versão paga sem anúncios.