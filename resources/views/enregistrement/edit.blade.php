                                            {{-- Champ obligatoire s'affiche pour tous les types de champs --}}
                                            <div class="row g-3 mt-2 align-items-center options-container"
                                                id="options_container_{{ $element->id }}">

                                                <div class="col-md-6">
                                                    <label class="form-label me-3 mb-0">Champ obligatoire <span
                                                            class="text-danger">*</span></label>

                                                    <div class="form-check form-check-inline">
                                                        {{-- Utilisation de la notation tableau pour les noms des radios --}}
                                                        <input type="radio"
                                                            class="form-check-input @error('elements.' . $element->id . '.required') is-invalid @enderror"
                                                            name="elements[{{ $element->id }}][required]" value="1"
                                                            id="required_{{ $element->id }}_yes"
                                                            {{ old('elements.' . $element->id . '.required', (string) $element->required) === '1' ? 'checked' : '' }}>
                                                        <label class="form-check-label"
                                                            for="required_{{ $element->id }}_yes">Oui</label>
                                                    </div>

                                                    <div class="form-check form-check-inline">
                                                        <input type="radio"
                                                            class="form-check-input @error('elements.' . $element->id . '.required') is-invalid @enderror"
                                                            name="elements[{{ $element->id }}][required]"
                                                            value="0" id="required_{{ $element->id }}_no"
                                                            {{ old('elements.' . $element->id . '.required', (string) $element->required) === '0' ? 'checked' : '' }}>
                                                        <label class="form-check-label"
                                                            for="required_{{ $element->id }}_no">Non</label>
                                                    </div>

                                                    @error('elements.' . $element->id . '.required')
                                                        <div class="text-danger mt-1">{{ $message }}</div>
                                                    @enderror
                                                </div>

                                                <div class="col-md-6">
                                                    <label for="options_{{ $element->id }}" class="form-label">
                                                        Options (séparées par une virgule)
                                                    </label>

                                                    {{-- Utilisation de la notation tableau pour le nom de l'input --}}
                                                    <input type="text"
                                                        class="form-control @error('elements.' . $element->id . '.options') is-invalid @enderror"
                                                        name="elements[{{ $element->id }}][options]"
                                                        id="options_{{ $element->id }}"
                                                        value="{{ old('elements.' . $element->id . '.options', $element->choix) }}"
                                                        {{ in_array(old('elements.' . $element->id . '.type', $element->type), ['select', 'checkbox', 'radio']) ? 'required' : '' }}
                                                        placeholder="Ex: Option 1, Option 2, Option 3">

                                                    @error('elements.' . $element->id . '.options')
                                                        <div class="invalid-feedback">{{ $message }}</div>
                                                    @enderror
                                                </div>
                                            </div>
