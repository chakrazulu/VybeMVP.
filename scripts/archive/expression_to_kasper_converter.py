#!/usr/bin/env python3
"""
Expression to KASPER Converter
Converts ChatGPT Expression JSON files to KASPER MLX production format
Uses the validated Expression schema structure for perfect compatibility
"""

import json
from datetime import datetime
from pathlib import Path
from typing import Any, Dict


class ExpressionKasperConverter:
    def __init__(self):
        self.base_dir = Path(__file__).parent.parent
        self.expression_schema = self.load_expression_schema()

    def load_expression_schema(self) -> Dict[str, Any]:
        """Load the validated Expression schema as template"""
        schema_path = self.base_dir / "NumerologyData" / "PERFECT_EXPRESSION_NUMBER_SCHEMA.json"
        with open(schema_path, "r", encoding="utf-8") as f:
            return json.load(f)

    def convert_expression_file(self, input_path: Path, number: int) -> Dict[str, Any]:
        """Convert ChatGPT Expression file to KASPER format"""

        # Load ChatGPT Expression file
        with open(input_path, "r", encoding="utf-8") as f:
            chatgpt_data = json.load(f)

        # Start with validated Expression schema as template
        kasper_data = json.loads(json.dumps(self.expression_schema))

        # Update meta section with Expression Number details
        kasper_data["meta"].update(
            {
                "id": f"expression_{number:02d}",
                "numerologyType": "expression",
                "number": number,
                "title": f"Expression Number {number}",
                "description": f"Communication style and natural talents for Expression {number}",
                "context": "expression",
                "lastUpdated": datetime.now().isoformat(),
                "sourceType": "chatgpt_behavioral",
                "conversionVersion": "v1.0",
            }
        )

        # Update trinity for Expression Number
        kasper_data["trinity"][
            "calculation"
        ] = "Sum all letters of the full birth name; reduce to a single digit or master number"
        kasper_data["trinity"][
            "meaning"
        ] = "Represents your natural communication style, talents, and how you express yourself in the world"
        kasper_data["trinity"]["resonance"] = "mental"

        # Use ChatGPT behavioral data directly (it should already match schema structure)
        if "behavioral" in chatgpt_data:
            kasper_data["profiles"][0]["behavioral"] = chatgpt_data["behavioral"]
        elif "profiles" in chatgpt_data and len(chatgpt_data["profiles"]) > 0:
            if "behavioral" in chatgpt_data["profiles"][0]:
                kasper_data["profiles"][0]["behavioral"] = chatgpt_data["profiles"][0]["behavioral"]

        # Update profile context
        kasper_data["profiles"][0]["context"] = "expression"
        kasper_data["profiles"][0]["number"] = number

        # Update generation instructions
        kasper_data["generation_instructions"]["context"] = "expression"
        kasper_data["generation_instructions"][
            "focus"
        ] = "Natural communication style, talents, and self-expression in the world"
        kasper_data["generation_instructions"]["model"] = "chatgpt-4"

        return kasper_data

    def convert_all_expression_files(self):
        """Convert all Expression files to KASPER format"""
        input_dir = self.base_dir / "NumerologyData" / "ImportedContent" / "ExpressionContent"
        output_dir = self.base_dir / "KASPERMLX" / "MLXTraining" / "ContentRefinery" / "Approved"

        print("🔄 EXPRESSION TO KASPER CONVERTER")
        print("=" * 42)
        print(f"Input directory: {input_dir}")
        print(f"Output directory: {output_dir}")
        print()

        # Find all expression files
        expression_files = list(input_dir.glob("expression_*_behavioral.json"))
        expression_files.sort()

        converted_files = []

        for file_path in expression_files:
            try:
                # Extract number from filename
                filename = file_path.name
                number_str = filename.split("_")[1]
                number = int(number_str)

                print(f"🔄 Converting Expression {number}...")

                # Convert to KASPER format
                kasper_data = self.convert_expression_file(file_path, number)

                # Save to production directory
                output_filename = f"expression_{number:02d}_converted.json"
                output_path = output_dir / output_filename

                with open(output_path, "w", encoding="utf-8") as f:
                    json.dump(kasper_data, f, indent=2, ensure_ascii=False)

                converted_files.append(output_filename)
                print(f"✅ Generated: {output_filename}")

            except Exception as e:
                print(f"❌ Error converting {file_path.name}: {e}")

        print()
        print("🎉 CONVERSION COMPLETE!")
        print(f"✅ Successfully converted {len(converted_files)} Expression files")
        print("🔮 Files ready for KASPER MLX consumption in Approved folder")
        print()
        print("📊 UPDATED PRODUCTION INVENTORY:")

        # Count all production files
        all_files = list(output_dir.glob("*.json"))
        soul_urge = len([f for f in all_files if f.name.startswith("soulUrge_")])
        life_path = len([f for f in all_files if f.name.startswith("lifePath_")])
        expression = len([f for f in all_files if f.name.startswith("expression_")])
        grok = len([f for f in all_files if f.name.startswith("grok_")])
        claude = len([f for f in all_files if f.name.startswith("claude_")])
        chatgpt = len([f for f in all_files if f.name.startswith("chatgpt_")])

        print(f"✅ Soul Urge: {soul_urge} files")
        print(f"✅ Life Path: {life_path} files")
        print(f"✅ Expression: {expression} files")
        print(f"✅ Grok Multi-Persona: {grok} files")
        print(f"✅ Claude Academic: {claude} files")
        print(f"✅ ChatGPT Original: {chatgpt} files")
        print(f"✅ TOTAL: {len(all_files)} production files")

        return converted_files


if __name__ == "__main__":
    converter = ExpressionKasperConverter()
    converter.convert_all_expression_files()
