# Trabajo Final: Creación de un Exchange Descentralizado Simple con Pools de Liquidez
---

### Descripción del Proyecto:

**Los estudiantes deben desplegar contratos inteligentes en la red de Scroll Sepolia (verificados y publicados) para implementar un exchange descentralizado simple que intercambie dos tokens ERC-20.**

#### La solución debe permitir:

- **Añadir liquidez:** El owner puede depositar pares de tokens en el pool para proporcionar liquidez.
- **Intercambiar tokens:** Los usuarios pueden intercambiar uno de los tokens por el otro utilizando el pool de liquidez.
- **Retirar liquidez:** El owner puede retirar sus participaciones en el pool.
---

#### Requisitos:

- **Crear dos tokens ERC-20 simples:** Los contratos de los tokens deben tener obligatoriamente los nombres TokenA y TokenB. &#x2611;


- **Implementar un contrato de exchange (denominado obligatoriamente **SimpleDEX**) que:**
    - Mantenga un pool de liquidez para **TokenA y TokenB**.
    - Utilice la fórmula del producto constante **(x+dx)(y-dy) = xy** para calcular los precios de intercambio. &#x2611;
    - Permita añadir y retirar liquidez. &#x2611;
    - Permita intercambiar TokenA por TokenB y viceversa.  &#x2611;
    
    
- **El contrato SimpleDEX debe contar obligatoriamente y sin modificación de la interface con las siguientes funciones:**
    - constructor(address _tokenA, address _tokenB) &#x2611;
    - addLiquidity(uint256 amountA, uint256 amountB) &#x2611;
    - swapAforB(uint256 amountAIn) &#x2611;
    - swapBforA(uint256 amountBIn) &#x2611;
    - removeLiquidity(uint256 amountA, uint256 amountB) &#x2611;
    - getPrice(address _token) &#x2611;

###### **Incluir los eventos que consideren convenientes.** &#x2611;
---

##### Objetivos de Aprendizaje:

- Comprender cómo funcionan los exchanges descentralizados y los pools de liquidez.
- Practicar la creación de tokens ERC-20 en Solidity.
- Aprender a implementar mecanismos de mercado automatizados simples.
- Llamar a otros contratos inteligentes.
---

###### ** **IMPORTANTE:** El trabajo debe ser presentado en la sección **TRABAJO FINAL MÓDULO 3** donde deben incluir las URLs de los tres contratos desplegados, verificados y publicados de la siguiente manera:**

- **Contrato TokenA**
    https://sepolia.scrollscan.com/address/0x3e…#code


- **Contrato TokenB**
    https://sepolia.scrollscan.com/address/0x56a…#code

- **Contrato SimpleDEX**
    https://sepolia.scrollscan.com/address/0xf0e…#code

###### **TIPS PARA EL TRABAJO FINAL:**  En este **[documento](https://docs.google.com/presentation/d/1xqKsfAws8zdRLW9tcdPdOWRCiQCrH6Nin83awWervnA/edit?usp=sharing)** encontrarán algunas explicaciones y recomendaciones que les servirán para llevar a buen término el trabajo final. 

También tienen a disposición el **[video](https://youtu.be/E5gcB6HO6Ik)** de la clase de explicación del trabajo final. 

|checked|unchecked|crossed|
|---|---|---|
|&check;|_|&cross;|
|&#x2611;|&#x2610;|&#x2612;|