import io
from reportlab.lib.pagesizes import letter, A4
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle

def generate_pdf(stats, annee):
    """
    Génère un document PDF en mémoire contenant le compte de résultat.
    """
    buffer = io.BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=A4, rightMargin=30, leftMargin=30, topMargin=30, bottomMargin=30)
    story = []
    
    styles = getSampleStyleSheet()
    
    # Styles personnalisés
    title_style = ParagraphStyle(
        name='TitleStyle',
        parent=styles['Heading1'],
        fontSize=18,
        leading=22,
        textColor=colors.HexColor("#1F4E79"),
        alignment=1, # Centré
        spaceAfter=20
    )
    
    # Titre
    story.append(Paragraph(f"Compte de Résultat — Année {annee}", title_style))
    story.append(Spacer(1, 15))
    
    # Extraction des données (adaptez selon la structure réelle de `stats`)
    produits = stats.get('produits', 0) if isinstance(stats, dict) else getattr(stats, 'produits', 0)
    charges = stats.get('charges', 0) if isinstance(stats, dict) else getattr(stats, 'charges', 0)
    resultat = produits - charges

    data = [
        ["Rubrique", "Montant (€)"],
        ["Total des Produits (Ventes, prestations...)", f"{produits:,.2f} €"],
        ["Total des Charges (Achats, loyers, salaires...)", f"{charges:,.2f} €"],
        ["Résultat Net (Bénéfice / Perte)", f"{resultat:,.2f} €"]
    ]
    
    table = Table(data, colWidths=[350, 150])
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#1F4E79")),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('ALIGN', (1, 0), (1, -1), 'RIGHT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
        ('TOPPADDING', (0, 0), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#D3D3D3")),
        # Style spécifique pour la dernière ligne (Résultat Net)
        ('BACKGROUND', (0, -1), (-1, -1), colors.HexColor("#D9E1F2")),
        ('FONTNAME', (0, -1), (-1, -1), 'Helvetica-Bold'),
    ]))
    
    story.append(table)
    
    # Construction du PDF
    doc.build(story)
    buffer.seek(0)
    return buffer.getvalue()