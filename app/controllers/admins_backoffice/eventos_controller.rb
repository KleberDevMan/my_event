class AdminsBackoffice::EventosController < AdminsBackofficeController
  before_action :set_evento, only: [:show, :edit, :update, :destroy]
  before_action :set_combos, only: [:new, :create, :edit, :update]

  # GET /eventos
  # GET /eventos.json
  def index
    @eventos = Evento.where(admin_id: current_admin[:id])
  end

  # GET /eventos/1
  # GET /eventos/1.json
  def show
  end

  # GET /eventos/new
  def new
    @evento = Evento.new
  end

  # GET /eventos/1/edit
  def edit
  end

  # POST /eventos
  # POST /eventos.json
  def create
    @evento = Evento.new(evento_params)

    respond_to do |format|
      if @evento.save
        format.html { redirect_to admins_backoffice_eventos_path, notice: t('messages.cadastrado') }
        format.json { render :show, status: :created, location: @evento }
      else
        format.html { render :new }
        format.json { render json: @evento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eventos/1
  # PATCH/PUT /eventos/1.json
  def update
    respond_to do |format|
      if @evento.update(evento_params)
        format.html { redirect_to admins_backoffice_eventos_path, notice: t('messages.alterado') }
        format.json { render :show, status: :ok, location: @evento }
      else
        format.html { render :edit }
        format.json { render json: @evento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eventos/1
  # DELETE /eventos/1.json
  def destroy
    @evento.destroy
    respond_to do |format|
      format.html { redirect_to admins_backoffice_eventos_path, notice: t('messages.deletado') }
      format.json { head :no_content }
    end
  end

  private

  def set_combos
    @parceiros = Parceiro.where(admin_id: current_admin[:id]).map { |p| [p.nome, p.id] }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_evento
    #@evento = Evento.includes(dias: [:atividades]).find(params[:id])
    @evento = Evento.left_outer_joins(dias: [:atividades]).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def evento_params
    params.require(:evento).permit(:titulo,
                                   :descricao,
                                   :local,
                                   :codigo,
                                   :admin_id,
                                   :imagem,
                                   parceiro_ids: [],
                                   dias_attributes: [:id, :data_s, :_destroy,
                                                     atividades_attributes: [:id, :titulo, :descricao, :hora_s, :_destroy]])
  end
end
