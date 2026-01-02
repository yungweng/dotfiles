# Citation Format Validator Command

## Purpose
Comprehensively validate and correct all literature references and in-text citations in a seminar paper section to match the exact specifications of any citation style (APA7, MLA9, Chicago 17th, IEEE, Harvard, etc.), ensuring perfect formatting compliance throughout.

## Prerequisites/Context
- Section of seminar paper with citations and references
- Specified citation style (e.g., APA7, MLA9, Chicago 17th)
- Access to bibliography/reference list
- Understanding of the specific version of the citation style
- Optional: DOI/URL access for verification

## Core Instructions

### 1. Style Recognition and Setup
```
CITATION STYLE ANALYSIS:
├── Style Guide: [APA7/MLA9/Chicago/IEEE/Harvard/etc.]
├── Style Version: [7th edition, 9th edition, etc.]
├── Total In-Text Citations: [count]
├── Total References: [count]
├── Citation Types Found: [books/journals/websites/etc.]
└── Current Compliance: [percentage correct]
```

### 2. Style-Specific Rule Engine

#### APA 7th Edition Rules
```python
apa7_rules = {
    'in_text_citations': {
        'single_author': {
            'narrative': '(Author, Year)',
            'parenthetical': '(Author, Year)',
            'with_page': '(Author, Year, p. #)'
        },
        'two_authors': {
            'narrative': 'Author1 and Author2 (Year)',
            'parenthetical': '(Author1 & Author2, Year)'
        },
        'three_plus_authors': {
            'first_citation': '(Author1 et al., Year)',
            'subsequent': '(Author1 et al., Year)'
        },
        'multiple_works': '(Author1, Year1; Author2, Year2)',
        'same_author_same_year': '(Author, 2023a, 2023b)'
    },
    
    'reference_list': {
        'journal_article': {
            'pattern': 'Author, A. A., & Author, B. B. (Year). Title of article. Title of Journal, volume(issue), pages. DOI',
            'italics': ['journal_name'],
            'capitalization': 'sentence_case_title',
            'doi_format': 'https://doi.org/xxxxx'
        },
        'book': {
            'pattern': 'Author, A. A. (Year). Title of book (edition). Publisher.',
            'italics': ['book_title'],
            'capitalization': 'sentence_case_title'
        },
        'website': {
            'pattern': 'Author, A. A. (Year, Month Day). Title of webpage. Website Name. URL',
            'italics': ['website_name'],
            'retrieval_date': 'only if content changes'
        }
    }
}
```

#### MLA 9th Edition Rules
```python
mla9_rules = {
    'in_text_citations': {
        'single_author': {
            'narrative': 'Author argues... (Page)',
            'parenthetical': '(Author Page)',
            'no_page': '(Author)'
        },
        'two_authors': '(Author1 and Author2 Page)',
        'three_plus_authors': '(Author1 et al. Page)',
        'no_author': '("Shortened Title" Page)'
    },
    
    'works_cited': {
        'journal_article': {
            'pattern': 'Author Last, First. "Article Title." Journal Title, vol. #, no. #, Year, pp. ##-##.',
            'punctuation': 'periods_after_elements',
            'italics': ['journal_title'],
            'quotes': ['article_title']
        },
        'book': {
            'pattern': 'Author Last, First. Book Title. Publisher, Year.',
            'italics': ['book_title']
        },
        'website': {
            'pattern': 'Author Last, First. "Page Title." Website Title, Date, URL.',
            'italics': ['website_title'],
            'quotes': ['page_title']
        }
    }
}
```

### 3. Citation Detection and Parsing

```python
class CitationDetector:
    def __init__(self, style_guide):
        self.style = style_guide
        self.citation_patterns = self.load_style_patterns()
        
    def scan_document(self, text):
        """Detect all citations in the document"""
        return {
            'in_text_citations': self.find_in_text_citations(text),
            'reference_entries': self.find_reference_entries(text),
            'cross_references': self.match_citations_to_references()
        }
    
    def find_in_text_citations(self, text):
        """Extract all in-text citations"""
        patterns = {
            'parenthetical': r'\([^)]*\d{4}[^)]*\)',
            'narrative': r'[A-Z][a-z]+ \(\d{4}\)',
            'page_numbers': r'p\.\s*\d+|pp\.\s*\d+-\d+',
            'et_al': r'et al\.'
        }
        return self.extract_matches(text, patterns)
    
    def parse_citation_components(self, citation):
        """Break down citation into components"""
        return {
            'authors': self.extract_authors(citation),
            'year': self.extract_year(citation),
            'page': self.extract_page(citation),
            'type': self.determine_citation_type(citation)
        }
```

### 4. Format Validation Engine

```python
class FormatValidator:
    def __init__(self, style_rules):
        self.rules = style_rules
        self.errors = []
        
    def validate_citation(self, citation, expected_style):
        """Check if citation matches style requirements"""
        validation = {
            'original': citation,
            'errors': [],
            'corrections': [],
            'severity': None
        }
        
        # Check punctuation
        if not self.check_punctuation(citation, expected_style):
            validation['errors'].append('Incorrect punctuation')
            
        # Check author format
        if not self.check_author_format(citation, expected_style):
            validation['errors'].append('Author format incorrect')
            
        # Check year placement
        if not self.check_year_placement(citation, expected_style):
            validation['errors'].append('Year placement incorrect')
            
        return validation
    
    def validate_reference(self, reference, ref_type):
        """Validate complete reference entry"""
        checks = {
            'author_format': self.validate_author_names(reference),
            'title_format': self.validate_title_capitalization(reference),
            'italics': self.validate_italic_usage(reference),
            'punctuation': self.validate_punctuation_sequence(reference),
            'completeness': self.validate_required_elements(reference, ref_type)
        }
        return checks
```

### 5. Automatic Correction System

```python
class CitationCorrector:
    def __init__(self, style_guide):
        self.style = style_guide
        self.corrections_made = []
        
    def auto_correct_citation(self, citation, context):
        """Automatically fix citation format"""
        components = self.parse_citation(citation)
        
        # Apply style-specific formatting
        if self.style == 'APA7':
            corrected = self.format_apa7_citation(components, context)
        elif self.style == 'MLA9':
            corrected = self.format_mla9_citation(components, context)
        elif self.style == 'Chicago17':
            corrected = self.format_chicago_citation(components, context)
            
        return {
            'original': citation,
            'corrected': corrected,
            'changes': self.describe_changes(citation, corrected)
        }
    
    def format_apa7_citation(self, components, context):
        """Format according to APA 7th edition"""
        authors = components['authors']
        year = components['year']
        
        if len(authors) == 1:
            if context == 'narrative':
                return f"{authors[0]} ({year})"
            else:
                return f"({authors[0]}, {year})"
        elif len(authors) == 2:
            if context == 'narrative':
                return f"{authors[0]} and {authors[1]} ({year})"
            else:
                return f"({authors[0]} & {authors[1]}, {year})"
        else:
            return f"({authors[0]} et al., {year})"
```

### 6. Cross-Reference Verification

```python
cross_reference_checker = {
    'orphan_citations': {
        'description': 'In-text citations without matching references',
        'action': 'Flag for missing reference entry',
        'severity': 'HIGH'
    },
    
    'orphan_references': {
        'description': 'References not cited in text',
        'action': 'Flag for removal or find missing citation',
        'severity': 'MEDIUM'
    },
    
    'mismatch_detection': {
        'year_mismatch': 'Citation year differs from reference',
        'author_mismatch': 'Author names inconsistent',
        'title_mismatch': 'Work title varies between citations'
    }
}
```

### 7. Comprehensive Output Report

```markdown
## Citation Format Validation Report

### Summary
- **Style Guide**: APA 7th Edition
- **Total Citations Checked**: 47
- **Corrections Made**: 23
- **Compliance Score**: Before: 51% → After: 100%

### In-Text Citation Corrections

#### Punctuation Corrections (8 instances)
**Before**: (Smith 2023)  
**After**: (Smith, 2023)  
**Rule**: APA requires comma between author and year

#### Author Format Corrections (5 instances)
**Before**: (Johnson & Williams & Davis, 2022)  
**After**: (Johnson et al., 2022)  
**Rule**: Three or more authors use "et al." in all citations

#### Narrative Citation Corrections (3 instances)
**Before**: (Miller, 2023) argues that...  
**After**: Miller (2023) argues that...  
**Rule**: In narrative citations, only year is parenthetical

### Reference List Corrections

#### Journal Articles (12 corrections)
**Before**: 
Smith, J. (2023). The Future Of AI. Nature, 591, 123-145.

**After**: 
Smith, J. (2023). The future of AI. *Nature*, *591*, 123-145. https://doi.org/10.1038/xxxxx

**Changes**:
- ✓ Title changed to sentence case
- ✓ Journal name italicized
- ✓ Volume number italicized
- ✓ DOI added in correct format

#### Books (5 corrections)
**Before**: 
Johnson, A. B. (2022). *Research Methods* (3rd edition). Oxford Press.

**After**: 
Johnson, A. B. (2022). *Research methods* (3rd ed.). Oxford University Press.

**Changes**:
- ✓ Title capitalization corrected
- ✓ Edition abbreviation standardized
- ✓ Publisher name completed

### Cross-Reference Issues

#### Missing References (3 found)
1. (Williams, 2021) - No matching reference entry
2. (Davis et al., 2020) - No matching reference entry
3. (Thompson, 2023) - No matching reference entry

#### Uncited References (2 found)
1. Martinez, P. (2022) - Not cited in text
2. Anderson, K. (2021) - Not cited in text

### Style-Specific Recommendations

1. **Consistency Issues**
   - Standardize "and" vs "&" usage (narrative vs parenthetical)
   - Ensure all DOIs use https://doi.org/ format
   - Check italicization is applied consistently

2. **Common Errors to Watch**
   - Missing commas in parenthetical citations
   - Incorrect et al. usage for first citations
   - Title capitalization (sentence case for APA)

### Compliance Checklist

✓ All in-text citations properly formatted
✓ All references follow APA 7th structure
✓ Punctuation corrected throughout
✓ Italics applied correctly
✓ DOIs formatted properly
✓ Cross-references verified
✓ Alphabetical order confirmed
✓ Hanging indent applied
```

### 8. Style Guide Quick Reference

```yaml
quick_reference:
  APA7:
    in_text: "(Author, Year)" or "Author (Year)"
    multiple: "(Author1, Year1; Author2, Year2)"
    page: "(Author, Year, p. 123)"
    
  MLA9:
    in_text: "(Author 123)" or "Author argues (123)"
    no_page: "(Author)"
    multiple: "(Author1 123; Author2 456)"
    
  Chicago17:
    notes: "¹Author, Title, page."
    bibliography: "Author. Title. Place: Publisher, Year."
    
  IEEE:
    in_text: "[1]" or "[1]-[3]"
    reference: "[1] A. Author, "Title," Journal, vol. X, no. Y, pp. 123-456, Year."
```

## Integration Notes

- Works seamlessly with `seminar-reference-auditor` for complete reference checking
- Complements `scientific-style-enforcer` for overall writing quality
- Can be chained with `seminar-section-enhancer` for comprehensive improvement
- Provides specific corrections ready for immediate application

## Anti-Patterns/Warnings

- DON'T change author names without verification
- DON'T modify quoted titles beyond capitalization
- DON'T assume one style guide rule applies to another
- DON'T auto-correct without showing changes
- DON'T ignore version differences (APA6 vs APA7)
- DON'T format web sources like print sources

## Validation Checklist

- [ ] Citation style and version specified
- [ ] All in-text citations detected
- [ ] All reference entries parsed
- [ ] Style-specific rules applied
- [ ] Cross-references verified
- [ ] Corrections clearly marked
- [ ] Original text preserved
- [ ] Compliance score calculated
- [ ] Manual review items flagged