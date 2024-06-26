"""Add currencies

Revision ID: 927ed575acbd
Revises: cb038f79982e
Create Date: 2020-04-25 14:49:41.136602

"""

# revision identifiers, used by Alembic.
revision = "927ed575acbd"
down_revision = "cb038f79982e"

from alembic import op
import sqlalchemy as sa
from ilovemoney.currency_convertor import CurrencyConverter


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column("bill", sa.Column("converted_amount", sa.Float(), nullable=True))
    op.add_column(
        "bill",
        sa.Column(
            "original_currency",
            sa.String(length=3),
            server_default=CurrencyConverter.no_currency,
            nullable=True,
        ),
    )
    op.add_column(
        "bill_version",
        sa.Column("converted_amount", sa.Float(), autoincrement=False, nullable=True),
    )
    op.add_column(
        "bill_version",
        sa.Column(
            "original_currency", sa.String(length=3), autoincrement=False, nullable=True
        ),
    )
    op.add_column(
        "project",
        sa.Column(
            "default_currency",
            sa.String(length=3),
            server_default=CurrencyConverter.no_currency,
            nullable=True,
        ),
    )
    op.add_column(
        "project_version",
        sa.Column(
            "default_currency", sa.String(length=3), autoincrement=False, nullable=True
        ),
    )
    # ### end Alembic commands ###
    op.execute(
        """
    UPDATE bill
    SET converted_amount = amount
    WHERE converted_amount IS NULL
    """
    )


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column("project_version", "default_currency")
    op.drop_column("project", "default_currency")
    op.drop_column("bill_version", "original_currency")
    op.drop_column("bill_version", "converted_amount")
    op.drop_column("bill", "original_currency")
    op.drop_column("bill", "converted_amount")
    # ### end Alembic commands ###
