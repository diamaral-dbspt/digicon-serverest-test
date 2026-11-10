import json
from pathlib import Path
from jsonschema import validate


def carregar_schema(arquivo_schema):
    caminho = Path(arquivo_schema)

    return json.loads(
        caminho.read_text(encoding="utf-8")
    )


def validar_contrato(corpo, arquivo_schema):
    """Valida um objeto contra um JSON Schema."""

    schema = carregar_schema(arquivo_schema)

    validate(
        instance=corpo,
        schema=schema
    )


def validar_lista_produtos(
    corpo,
    arquivo_schema_lista,
    arquivo_schema_produto
):
    """Valida a resposta da consulta e cada produto retornado."""

    schema_lista = carregar_schema(arquivo_schema_lista)
    schema_produto = carregar_schema(arquivo_schema_produto)

    # Valida a estrutura principal da resposta
    validate(
        instance=corpo,
        schema=schema_lista
    )

    # Valida individualmente cada produto
    for indice, produto in enumerate(corpo["produtos"]):

        try:
            validate(
                instance=produto,
                schema=schema_produto
            )

        except Exception as erro:
            raise AssertionError(
                f"Produto na posição {indice} "
                f"não respeita o contrato: {erro}"
            ) from erro