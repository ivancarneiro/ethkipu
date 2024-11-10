**Trabajo Práctito Final Módulo 2 (Auction Smart Contract)**
===
***


## Se requiere un contrato inteligente verificado y publicado en la red de Scroll Sepolia que cumpla con lo siguiente:


### **Funciones básicas**
- **Constructor:** Inicializar la subasta con los parámetros necesarios.
- **Ofertar:** Permitir que los participantes hagan una oferta válida (superior en al menos 5% a la actual) mientras la subasta esté activa.
- **Mostrar ganador:** Mostrar el ganador y el monto de la oferta ganadora.
- **Mostrar ofertas:** Listar todos los ofertantes y sus montos.
- **Devolver depósitos:** Al finalizar, devolver los depósitos a quienes no ganaron (menos una comisión del 2% para el gas).


### **Funcionalidades avanzadas**
- **Reembolso parcial:** Los participantes pueden retirar el exceso de su última oferta.
- **Extensión del plazo:** La subasta se extiende 10 minutos con cada nueva oferta válida en los últimos 10 minutos.


### **Consideraciones importantes**
- Usen modificadores donde sea adecuado.
- Una vez finalizada la subasta el propietario del contrato ejecutará una función para devolver el depósito a los ofertantes que no ganaron y transferir el premio al ganador (El importe de la mejor oferta).  El propietario no interviene en la finalización de la subasta. La subasta tiene una duración predefinida y se puede extender en la medida en que sigan llegando nuevas ofertas.

---
*Asegúrense de manejar adecuadamente los errores y usar eventos para comunicar cambios de estado.*


*Documentación clara y completa explicando funciones, variables y eventos.*
