<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visualisation du formulaire - {{ isset($enregistrement) ? $enregistrement->libelle : 'Formulaire' }}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --google-blue: #4285f4;
            --google-blue-hover: #3367d6;
            --google-red: #ea4335;
            --google-gray: rgba(248, 249, 250, 0.9);
            --google-border: #dadce0;
            --google-text-primary: #202124;
            --google-text-secondary: #5f6368;
            --google-shadow: 0 1px 2px 0 rgba(60, 64, 67, .3), 0 2px 6px 2px rgba(60, 64, 67, .15);
            --google-shadow-hover: 0 1px 3px 0 rgba(60, 64, 67, .302), 0 4px 8px 3px rgba(60, 64, 67, .149);
            --google-radius: 8px;
            --google-transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            background: url('https://images.unsplash.com/photo-1497366811353-6870744d04b2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') no-repeat center center;
            background-size: cover;
            min-height: 100vh;
            padding: 40px 20px;
            position: relative;
            font-family: 'Google Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.85);
            z-index: 0;
        }

        .google-form-container {
            max-width: 640px;
            margin: 0 auto;
            background: #fff;
            border-radius: var(--google-radius);
            box-shadow: var(--google-shadow);
            padding: 40px 40px 32px;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .google-form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 10px;
            background: linear-gradient(90deg, #4285f4, #34a853, #fbbc05, #ea4335);
        }

        .form-header {
            display: flex;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--google-border);
        }

        .direction-logo {
            height: 60px;
            margin-right: 20px;
        }

        .header-text {
            flex: 1;
        }

        .google-form-title {
            font-size: 28px;
            font-weight: 500;
            color: var(--google-text-primary);
            margin-bottom: 4px;
        }

        .google-form-desc {
            color: var(--google-text-secondary);
            font-size: 14px;
            line-height: 1.5;
        }

        .google-form-desc strong {
            color: var(--google-text-primary);
        }

        .google-form-label {
            font-weight: 500;
            color: var(--google-text-primary);
            margin-bottom: 8px;
            display: block;
            font-size: 14px;
        }

        .google-form-label .required {
            color: var(--google-red);
            margin-left: 4px;
        }

        .google-form-group {
            margin-bottom: 32px;
            position: relative;
            transition: var(--google-transition);
            background: var(--google-gray);
            padding: 16px;
            border-radius: var(--google-radius);
            border: 1px solid transparent;
        }

        .google-form-group:hover {
            background: rgba(241, 243, 244, 0.9);
            border-color: var(--google-border);
        }

        .google-form-input,
        .google-form-select,
        .google-form-textarea {
            width: 100%;
            border: 1px solid var(--google-border);
            border-radius: var(--google-radius);
            padding: 13px 15px;
            font-size: 14px;
            background: #fff;
            transition: var(--google-transition);
            outline: none;
            color: var(--google-text-primary);
        }

        .google-form-input::placeholder,
        .google-form-textarea::placeholder {
            color: #9aa0a6;
            opacity: 1;
        }

        .google-form-input:focus,
        .google-form-select:focus,
        .google-form-textarea:focus {
            border-color: var(--google-blue);
            box-shadow: 0 0 0 2px rgba(66, 133, 244, .2);
        }

        .google-form-radio,
        .google-form-checkbox {
            accent-color: var(--google-blue);
            margin-right: 10px;
            width: 16px;
            height: 16px;
            vertical-align: middle;
            position: relative;
            top: -1px;
        }

        .google-form-options {
            margin-top: 10px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .google-form-options .form-check-label {
            font-weight: 400;
            color: var(--google-text-primary);
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
        }

        .google-form-btn-container {
            display: flex;
            justify-content: space-between;
            margin-top: 24px;
            padding-top: 16px;
            border-top: 1px solid var(--google-border);
        }

        .google-form-btn {
            background: var(--google-blue);
            color: #fff;
            border: none;
            border-radius: var(--google-radius);
            padding: 10px 24px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--google-transition);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 40px;
        }

        .google-form-btn:hover {
            background: var(--google-blue-hover);
            box-shadow: var(--google-shadow-hover);
        }

        .google-form-btn.secondary {
            background: #fff;
            color: var(--google-blue);
            border: 1px solid var(--google-border);
        }

        .google-form-btn.secondary:hover {
            background: #f8f9fa;
            border-color: #c6c9cc;
        }

        .google-form-select {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%235f6368'%3e%3cpath d='M7 10l5 5 5-5z'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 20px;
            padding-right: 36px;
        }

        @media (max-width: 768px) {
            body {
                padding: 20px 12px;
            }

            .google-form-container {
                padding: 32px 20px;
            }

            .form-header {
                flex-direction: column;
                text-align: center;
            }

            .direction-logo {
                margin-right: 0;
                margin-bottom: 15px;
                height: 50px;
            }

            .google-form-title {
                font-size: 24px;
            }

            .google-form-btn-container {
                flex-direction: column-reverse;
                gap: 12px;
            }

            .google-form-btn {
                width: 100%;
            }
        }

        .is-invalid {
            border-color: var(--google-red) !important;
        }

        .invalid-feedback {
            color: var(--google-red);
            font-size: 12px;
            margin-top: 6px;
        }
    </style>
</head>

<body>
    <div class="google-form-container">
        <div class="form-header">
            <img src="{{ $logoDirection }}" alt="Logo de la direction" class="direction-logo">
            <div class="header-text">
                <div class="google-form-title">{{ $enregistrement->libelle }}</div>
                <div class="google-form-desc">
                    <strong>Code :</strong> {{ $enregistrement->code }}<br>
                    <span>{{ $enregistrement->description }}</span>
                </div>
            </div>
        </div>
        <form>
            @foreach ($elements as $element)
                <div class="google-form-group">
                    <label class="google-form-label">
                        {{ $element->label }}
                        @if ($element->required)
                            <span class="required">*</span>
                        @endif
                    </label>
                    @php
                        $type = $element->type;
                        $name = 'field_' . $element->id;
                        $required = $element->required ? 'required' : '';
                        $options = $element->choix ? explode(',', $element->choix) : [];
                    @endphp
                    @if (in_array($type, ['text', 'email', 'number', 'date', 'password']))
                        <input type="{{ $type }}" name="{{ $name }}" class="google-form-input"
                            {{ $required }} placeholder="{{ $element->placeholder ?? '' }}">
                    @elseif ($type === 'textarea')
                        <textarea name="{{ $name }}" class="google-form-textarea" rows="4" {{ $required }}
                            placeholder="{{ $element->placeholder ?? '' }}"></textarea>
                    @elseif ($type === 'select')
                        <select name="{{ $name }}" class="google-form-select" {{ $required }}>
                            <option value="" disabled selected>{{ $element->placeholder ?? 'Sélectionner...' }}
                            </option>
                            @foreach ($options as $option)
                                <option value="{{ trim($option) }}">{{ trim($option) }}</option>
                            @endforeach
                        </select>
                    @elseif ($type === 'radio')
                        <div class="google-form-options">
                            @foreach ($options as $option)
                                <label class="form-check-label">
                                    <input class="google-form-radio" type="radio" name="{{ $name }}"
                                        value="{{ trim($option) }}" {{ $required }}>
                                    {{ trim($option) }}
                                </label>
                            @endforeach
                        </div>
                    @elseif ($type === 'checkbox')
                        <div class="google-form-options">
                            @foreach ($options as $option)
                                <label class="form-check-label">
                                    <input class="google-form-checkbox" type="checkbox" name="{{ $name }}[]"
                                        value="{{ trim($option) }}" {{ $required ? 'required' : '' }}>
                                    {{ trim($option) }}
                                </label>
                            @endforeach
                        </div>
                    @else
                        <input type="text" name="{{ $name }}" class="google-form-input"
                            {{ $required }}>
                    @endif
                </div>
            @endforeach
            <div class="google-form-btn-container">
                <a href="{{ url('/') }}" class="google-form-btn secondary">Retour</a>
                <button type="submit" class="google-form-btn">Envoyer</button>
            </div>
        </form>
    </div>
</body>

</html>
